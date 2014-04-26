
module.exports = (opts, callback***REMOVED***->
  s = this
  if !s.redis_client || !s.mongo_client
    s.opts = opts
    s.redis = require "redis"
    s.redis_client = s.redis.createClient opts.redis_port, opts.redis_host,
      auth_pass: opts.redis_password
    console.log "Redis connected"
    s.mongo_client = require('mongodb'***REMOVED***.MongoClient
    s.mongo_client.connect("mongodb://#{opts.mongo_db_host}/#{opts.mongo_db_name}", (err, db***REMOVED***->
      console.dir "Mongo connected: ", err
      s.mongo_db = db
      sClient = new SteamClient s.redis_client, s.mongo_db, s.opts
      if "function" == typeof(callback***REMOVED***
        callback(null, sClient***REMOVED***
    ***REMOVED***
  else
    if "function" == typeof(callback***REMOVED***
      callback(null, new SteamClient s.redis_client, s.mongo_db, s.opts***REMOVED***

class SteamClient
  KEYS:
    STEAM_APPLIST_REFRESH: 'STEAM.APPLIST.REFRESH'
    STEAM_APPLIST_RAW: 'STEAM.APPLIST.RAW'
    STEAM_APP_IDS: 'STEAM.APP_IDS'
    STEAM_APP_SUCCESS_IDS: 'STEAM.APP_SUCCESS_IDS'
    STEAM_METACRITIC_SCORES: 'STEAM.METACRITIC_SCORES'
    MDB_STEAM_APPS: 'steam_apps'

  constructor: (redis_client, mongo_db, opts***REMOVED*** ->
    this.jsonpack = require('jsonpack/main'***REMOVED***
    this.opts = opts
    this.unirest = require "unirest"
    this.xml2js = require("xml2js"***REMOVED***
    this.redis_client = redis_client
    this.mongo_db = mongo_db

  get_user_steamId_details: (user_id, callback***REMOVED***->
    #first, try grabbing custom url
    s = this

    #heuristically match steam64 pattern. If it matches, chance is that we should match using steam64 url first
    if /^[0-9]{17,25}$/.test(user_id***REMOVED***
      custom_url = [s.opts.steam_web_api_64_url + user_id, s.opts.steam_web_api_custom_url + user_id]
    else
      custom_url = [s.opts.steam_web_api_custom_url + user_id, s.opts.steam_web_api_64_url + user_id]

    #if id matches STEAM_ID, convert to steamID isntead
    if sid = /^STEAM_([0-9]{1,10}***REMOVED***:([0-9]{1,10}***REMOVED***:([0-9]{1,10}***REMOVED***$/.exec user_id
      w = parseInt(sid[3]***REMOVED*** * 2 + parseInt(sid[2]***REMOVED***
      custom_url.unshift s.opts.steam_web_api_id_url + "[U:1:#{w}]"

    e = (c***REMOVED***->
      s.unirest.get(custom_url[c]***REMOVED***
      .query({xml: 1}***REMOVED***
      .end (response***REMOVED*** =>
          s.xml2js.parseString response.body, (err, result***REMOVED***=>
            if !err
              if result.profile
                if "function" == typeof(callback***REMOVED***
                  callback(null, {
                    steamID64: result.profile.steamID64
                    customURL: result.profile.customURL
                ***REMOVED******REMOVED***
              else
                c++
                if c < custom_url.length
                  e(c***REMOVED***
                else
                  if "function" == typeof(callback***REMOVED***
                    callback("Cannot find Steam profile for specified ID: #{user_id}", null***REMOVED***
            else
              if "function" == typeof(callback***REMOVED***
                callback(err, null***REMOVED***
    e(0***REMOVED***

  get_recommendation: (user_id, callback***REMOVED***->
    s = this
    s.get_recommendation(user_id, (err, steams***REMOVED***->
      if !err

      else
        if "function" == typeof(callback***REMOVED***
          callback(err, null***REMOVED***
    ***REMOVED***

  get_user_owned_games: (steam_id, callback***REMOVED***->
    console.log "get_user_owned_games: #{steam_id}"
    s = this
    s.get_user_steamId_details steam_id, (err, steam_id_result***REMOVED*** ->
      if !err
        s.redis_client.GET("USER.#{steam_id}.CACHED_APP", (err, cached_app_list***REMOVED***->
          if (err || !cached_app_list***REMOVED*** #no cache
            console.log "- cache not found, getting owned games list for: #{steam_id}"
            s.unirest.get(s.opts.steam_web_api_user_api + "GetOwnedGames/v0001"***REMOVED*** # query steam for user's app list
            .query(
                key: s.opts.steam_web_api_key
                steamid: steam_id_result.steamID64
                format: "json"
              ***REMOVED***
            .end (response***REMOVED***=>
              console.log "- finished getting owned games list for: #{steam_id}"
              result = response.body
              if result && result.response
                if "function" == typeof(callback***REMOVED***
                  app_ids = []
                  play_time = {}
                  for game in result.response.games
                    appIdInt = parseInt(game.appid***REMOVED***
                    app_ids.push appIdInt
                    play_time[appIdInt] = game.playtime_forever
                  s.mongo_db.collection(s.KEYS.MDB_STEAM_APPS***REMOVED***.find({
                      _id: {$in: app_ids}
                  ***REMOVED***,{
                      name: 1
                      website: 1
                      required_age: 1
                      pc_requirement: 1
                      mac_requirement: 1
                      linux_requirement: 1
                      developers: 1
                      publishers: 1
                      price_overview: 1
                      package_groups: 1
                      platforms: 1
                      categories: 1
                      genres: 1
                      achievements: 1
                      release_date: 1
                      metacritic: 1
                      header_image: 1
                  ***REMOVED***
                  ***REMOVED***.toArray((err, game_details***REMOVED***->
                    if "function" == typeof(callback***REMOVED***
                      for game in game_details
                        game.playtime_forever = play_time[game._id]

                      result = {
                        game_count: result.response.game_count
                        in_db_count: game_details.length
                        games: game_details
                    ***REMOVED***

                      callback(null, result***REMOVED***
                      console.log "- finished getting game details for: #{steam_id}"
                    s.redis_client.SETEX ["USER.#{steam_id}.CACHED_APP", s.opts.steam_user_app_cache_validity, s.jsonpack.pack(result***REMOVED***], (err, result***REMOVED***->
                      return
                  ***REMOVED***
              else
                if "function" == typeof(callback***REMOVED***
                  callback("Error loading user app list from steam"***REMOVED***
          else #has cache
            console.log "- return cache for: #{steam_id}"
            if "function" == typeof(callback***REMOVED*** #simply return cached list
              callback(null, s.jsonpack.unpack(cached_app_list***REMOVED******REMOVED***
        ***REMOVED***
      else
        if "function" == typeof(callback***REMOVED***
          callback(err, null***REMOVED***

  _push_obj_to_redis: (root, prefix = "", obj***REMOVED***->

    for key of obj
      val = obj[key]
      if val instanceof Array
        this.redis_client.HSET root, prefix + ":" + key + ":length", val.length
        for i of val
          this._push_obj_to_redis root, prefix + ":" + key + ":" + i, if 'object' == typeof val[i] then val[i] else {val: val[i]}

      else if 'object' == typeof val
        this._push_obj_to_redis root, prefix + ":" + key, val
      else
        this.redis_client.HSET root, prefix + ":" + key, val

  _grab_data_from_steam: (***REMOVED***->
    s = this
    s.redis_client.LRANGE s.KEYS.STEAM_APP_IDS, 0, -1, (e, app_list***REMOVED***->
      batch = s.opts.n_of_app_in_query_batch
      i = 0

      while (i <= app_list.length***REMOVED***
        s.unirest.get("http://store.steampowered.com/api/appdetails/"***REMOVED***
        .query({
              appids: app_list[i..i + batch - 1].toString(***REMOVED***
      ***REMOVED******REMOVED***
        .end((response***REMOVED*** =>
          sdata = response.body
          for app_id of sdata
            item = sdata[app_id]
            if item.success && item.data
              id = parseInt(app_id***REMOVED***
              item.data._id = id
              s.mongo_db.collection(s.KEYS.MDB_STEAM_APPS***REMOVED***.update {_id: parseInt(id***REMOVED***}, item.data, {upsert: true}, (err, count***REMOVED***->
                return null
#                if "undefined" != typeof(item.data.metacritic***REMOVED*** && "undefined" != typeof(item.data.metacritic.score***REMOVED***
#                  s.redis_client.ZADD s.KEYS.STEAM_METACRITIC_SCORES, item.data.metacritic.score, app_id
#                s._push_obj_to_redis("STEAM.#{app_id}", "" , item.data***REMOVED***
          ***REMOVED***
        i += batch

  #Convert the list of app to STEAM_APP_IDS redis list
  _read_app_list: (***REMOVED***->
    s = this
    s.redis_client.GET s.KEYS.STEAM_APPLIST_RAW, (e, app_list_raw***REMOVED*** ->
      s.redis_client.DEL s.KEYS.STEAM_APP_IDS
      steam_apps = (JSON.parse app_list_raw***REMOVED***
      for app in steam_apps.applist.apps.app
        s.redis_client.RPUSH s.KEYS.STEAM_APP_IDS, app.appid

      console.log "Start grabbing from Steam"
      s._grab_data_from_steam(***REMOVED***

  #Get a list of app from Steam
  #If Refresh key is still there (not expired***REMOVED*** and there is a APPLIST_RAW, do not refresh
  _get_app_list: (***REMOVED***->
    s = this
    s.redis_client.GET s.KEYS.STEAM_APPLIST_REFRESH, (err, steam_refresh***REMOVED*** ->
      s.redis_client.GET s.KEYS.STEAM_APPLIST_RAW, (e, exists***REMOVED*** ->
        if steam_refresh && exists
          s._read_app_list(***REMOVED***
        else
          s.unirest.get('http://api.steampowered.com/ISteamApps/GetAppList/v0001/'***REMOVED***
          .end (response***REMOVED*** =>
              s.redis_client.SET s.KEYS.STEAM_APPLIST_RAW, response.raw_body
              s.redis_client.SET s.KEYS.STEAM_APPLIST_REFRESH, true
              s.redis_client.EXPIRE s.KEYS.STEAM_APPLIST_REFRESH, s.opts.steam_app_cache_validity
              s._read_app_list(***REMOVED***