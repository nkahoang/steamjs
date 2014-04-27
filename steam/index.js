***REMOVED***
(function(***REMOVED*** {
  var SteamClient;

  module.exports = function(opts, callback***REMOVED*** {
    var s;
    s = this;
    if (!s.redis_client || !s.mongo_client***REMOVED*** {
      s.opts = opts;
      s.redis = require("redis"***REMOVED***;
      s.redis_client = s.redis.createClient(opts.redis_port, opts.redis_host, {
        auth_pass: opts.redis_password
    ***REMOVED******REMOVED***;
      console.log("Redis connected"***REMOVED***;
      s.mongo_client = require('mongodb'***REMOVED***.MongoClient;
      return s.mongo_client.connect("mongodb://" + opts.mongo_db_host + "/" + opts.mongo_db_name, function(err, db***REMOVED*** {
        var sClient;
        if (err***REMOVED*** {
          console.dir("Mongo connect error: ", err***REMOVED***;
      ***REMOVED*** else {
          console.log("Mongo connected"***REMOVED***;
      ***REMOVED***
        s.mongo_db = db;
        sClient = new SteamClient(s.redis_client, s.mongo_db, s.opts***REMOVED***;
        if ("function" === typeof callback***REMOVED*** {
          return callback(null, sClient***REMOVED***;
      ***REMOVED***
    ***REMOVED******REMOVED***;
  ***REMOVED*** else {
      if ("function" === typeof callback***REMOVED*** {
        return callback(null, new SteamClient(s.redis_client, s.mongo_db, s.opts***REMOVED******REMOVED***;
    ***REMOVED***
  ***REMOVED***
***REMOVED***;

  SteamClient = (function(***REMOVED*** {
    SteamClient.prototype.KEYS = {
      STEAM_APPLIST_REFRESH: 'STEAM.APPLIST.REFRESH',
      STEAM_APPLIST_RAW: 'STEAM.APPLIST.RAW',
      STEAM_APP_IDS: 'STEAM.APP_IDS',
      STEAM_APP_SUCCESS_IDS: 'STEAM.APP_SUCCESS_IDS',
      STEAM_METACRITIC_SCORES: 'STEAM.METACRITIC_SCORES',
      MDB_STEAM_APPS: 'steam_apps'
  ***REMOVED***;

    function SteamClient(redis_client, mongo_db, opts***REMOVED*** {
      this.jsonpack = require('jsonpack/main'***REMOVED***;
      this.opts = opts;
      this.unirest = require("unirest"***REMOVED***;
      this.xml2js = require("xml2js"***REMOVED***;
      this.redis_client = redis_client;
      this.mongo_db = mongo_db;
  ***REMOVED***

    SteamClient.prototype.get_user_steamId_details = function(user_id, callback***REMOVED*** {
      var custom_url, e, s, sid, w;
      s = this;
      if (/^[0-9]{17,25}$/.test(user_id***REMOVED******REMOVED*** {
        custom_url = [s.opts.steam_web_api_64_url + user_id, s.opts.steam_web_api_custom_url + user_id];
    ***REMOVED*** else {
        custom_url = [s.opts.steam_web_api_custom_url + user_id, s.opts.steam_web_api_64_url + user_id];
    ***REMOVED***
      if (sid = /^STEAM_([0-9]{1,10}***REMOVED***:([0-9]{1,10}***REMOVED***:([0-9]{1,10}***REMOVED***$/.exec(user_id***REMOVED******REMOVED*** {
        w = parseInt(sid[3]***REMOVED*** * 2 + parseInt(sid[2]***REMOVED***;
        custom_url.unshift(s.opts.steam_web_api_id_url + ("[U:1:" + w + "]"***REMOVED******REMOVED***;
    ***REMOVED***
      e = function(c***REMOVED*** {
        return s.unirest.get(custom_url[c]***REMOVED***.query({
          xml: 1
      ***REMOVED******REMOVED***.end((function(_this***REMOVED*** {
          return function(response***REMOVED*** {
            return s.xml2js.parseString(response.body, function(err, result***REMOVED*** {
              if (!err***REMOVED*** {
                if (result.profile***REMOVED*** {
                  if ("function" === typeof callback***REMOVED*** {
                    return callback(null, {
                      steamID64: result.profile.steamID64,
                      customURL: result.profile.customURL
                  ***REMOVED******REMOVED***;
                ***REMOVED***
              ***REMOVED*** else {
                  c++;
                  if (c < custom_url.length***REMOVED*** {
                    return e(c***REMOVED***;
                ***REMOVED*** else {
                    if ("function" === typeof callback***REMOVED*** {
                      return callback("Cannot find Steam profile for specified ID: " + user_id, null***REMOVED***;
                  ***REMOVED***
                ***REMOVED***
              ***REMOVED***
            ***REMOVED*** else {
                if ("function" === typeof callback***REMOVED*** {
                  return callback(err, null***REMOVED***;
              ***REMOVED***
            ***REMOVED***
          ***REMOVED******REMOVED***;
        ***REMOVED***;
      ***REMOVED******REMOVED***(this***REMOVED******REMOVED***;
    ***REMOVED***;
      return e(0***REMOVED***;
  ***REMOVED***;

    SteamClient.prototype.get_recommendation = function(user_id, callback***REMOVED*** {
      var s;
      s = this;
      return s.get_recommendation(user_id, function(err, steams***REMOVED*** {
        if (!err***REMOVED*** {

      ***REMOVED*** else {
          if ("function" === typeof callback***REMOVED*** {
            return callback(err, null***REMOVED***;
        ***REMOVED***
      ***REMOVED***
    ***REMOVED******REMOVED***;
  ***REMOVED***;

    SteamClient.prototype.get_user_owned_games = function(steam_id, callback***REMOVED*** {
      var s;
      console.log("get_user_owned_games: " + steam_id***REMOVED***;
      s = this;
      return s.get_user_steamId_details(steam_id, function(err, steam_id_result***REMOVED*** {
        if (!err***REMOVED*** {
          return s.redis_client.GET("USER." + steam_id + ".CACHED_APP", function(err, cached_app_list***REMOVED*** {
            if (err || !cached_app_list***REMOVED*** {
              console.log("- cache not found, getting owned games list for: " + steam_id***REMOVED***;
              return s.unirest.get(s.opts.steam_web_api_user_api + "GetOwnedGames/v0001"***REMOVED***.query({
                key: s.opts.steam_web_api_key,
                steamid: steam_id_result.steamID64,
                format: "json"
            ***REMOVED******REMOVED***.end((function(_this***REMOVED*** {
                return function(response***REMOVED*** {
                  var appIdInt, app_ids, game, play_time, result, _i, _len, _ref;
                  console.log("- finished getting owned games list for: " + steam_id***REMOVED***;
                  result = response.body;
                  if (result && result.response***REMOVED*** {
                    if ("function" === typeof callback***REMOVED*** {
                      app_ids = [];
                      play_time = {};
                      _ref = result.response.games;
                      for (_i = 0, _len = _ref.length; _i < _len; _i++***REMOVED*** {
                        game = _ref[_i];
                        appIdInt = parseInt(game.appid***REMOVED***;
                        app_ids.push(appIdInt***REMOVED***;
                        play_time[appIdInt] = game.playtime_forever;
                    ***REMOVED***
                      return s.mongo_db.collection(s.KEYS.MDB_STEAM_APPS***REMOVED***.find({
                        _id: {
                          $in: app_ids
                      ***REMOVED***
                    ***REMOVED***, {
                        name: 1,
                        website: 1,
                        required_age: 1,
                        pc_requirement: 1,
                        mac_requirement: 1,
                        linux_requirement: 1,
                        developers: 1,
                        publishers: 1,
                        price_overview: 1,
                        package_groups: 1,
                        platforms: 1,
                        categories: 1,
                        genres: 1,
                        achievements: 1,
                        release_date: 1,
                        metacritic: 1,
                        header_image: 1
                    ***REMOVED******REMOVED***.toArray(function(err, game_details***REMOVED*** {
                        var _j, _len1;
                        if ("function" === typeof callback***REMOVED*** {
                          for (_j = 0, _len1 = game_details.length; _j < _len1; _j++***REMOVED*** {
                            game = game_details[_j];
                            game.playtime_forever = play_time[game._id];
                        ***REMOVED***
                          result = {
                            game_count: result.response.game_count,
                            in_db_count: game_details.length,
                            games: game_details
                        ***REMOVED***;
                          callback(null, result***REMOVED***;
                          console.log("- finished getting game details for: " + steam_id***REMOVED***;
                      ***REMOVED***
                        return s.redis_client.SETEX(["USER." + steam_id + ".CACHED_APP", s.opts.steam_user_app_cache_validity, s.jsonpack.pack(result***REMOVED***], function(err, result***REMOVED*** {}***REMOVED***;
                    ***REMOVED******REMOVED***;
                  ***REMOVED***
                ***REMOVED*** else {
                    if ("function" === typeof callback***REMOVED*** {
                      return callback("Error loading user app list from steam"***REMOVED***;
                  ***REMOVED***
                ***REMOVED***
              ***REMOVED***;
            ***REMOVED******REMOVED***(this***REMOVED******REMOVED***;
          ***REMOVED*** else {
              console.log("- return cache for: " + steam_id***REMOVED***;
              if ("function" === typeof callback***REMOVED*** {
                return callback(null, s.jsonpack.unpack(cached_app_list***REMOVED******REMOVED***;
            ***REMOVED***
          ***REMOVED***
        ***REMOVED******REMOVED***;
      ***REMOVED*** else {
          if ("function" === typeof callback***REMOVED*** {
            return callback(err, null***REMOVED***;
        ***REMOVED***
      ***REMOVED***
    ***REMOVED******REMOVED***;
  ***REMOVED***;

    SteamClient.prototype._push_obj_to_redis = function(root, prefix, obj***REMOVED*** {
      var i, key, val, _results;
      if (prefix == null***REMOVED*** {
        prefix = "";
    ***REMOVED***
      _results = [];
      for (key in obj***REMOVED*** {
        val = obj[key];
        if (val instanceof Array***REMOVED*** {
          this.redis_client.HSET(root, prefix + ":" + key + ":length", val.length***REMOVED***;
          _results.push((function(***REMOVED*** {
            var _results1;
            _results1 = [];
            for (i in val***REMOVED*** {
              _results1.push(this._push_obj_to_redis(root, prefix + ":" + key + ":" + i, 'object' === typeof val[i] ? val[i] : {
                val: val[i]
            ***REMOVED******REMOVED******REMOVED***;
          ***REMOVED***
            return _results1;
        ***REMOVED******REMOVED***.call(this***REMOVED******REMOVED***;
      ***REMOVED*** else if ('object' === typeof val***REMOVED*** {
          _results.push(this._push_obj_to_redis(root, prefix + ":" + key, val***REMOVED******REMOVED***;
      ***REMOVED*** else {
          _results.push(this.redis_client.HSET(root, prefix + ":" + key, val***REMOVED******REMOVED***;
      ***REMOVED***
    ***REMOVED***
      return _results;
  ***REMOVED***;

    SteamClient.prototype._grab_data_from_steam = function(***REMOVED*** {
      var s;
      s = this;
      return s.redis_client.LRANGE(s.KEYS.STEAM_APP_IDS, 0, -1, function(e, app_list***REMOVED*** {
        var batch, i, _results;
        batch = s.opts.n_of_app_in_query_batch;
        i = 0;
        _results = [];
        while (i <= app_list.length***REMOVED*** {
          s.unirest.get("http://store.steampowered.com/api/appdetails/"***REMOVED***.query({
            appids: app_list.slice(i, +(i + batch - 1***REMOVED*** + 1 || 9e9***REMOVED***.toString(***REMOVED***
        ***REMOVED******REMOVED***.end((function(_this***REMOVED*** {
            return function(response***REMOVED*** {
              var app_id, id, item, sdata, _results1;
              sdata = response.body;
              _results1 = [];
              for (app_id in sdata***REMOVED*** {
                item = sdata[app_id];
                if (item.success && item.data***REMOVED*** {
                  id = parseInt(app_id***REMOVED***;
                  item.data._id = id;
                  _results1.push(s.mongo_db.collection(s.KEYS.MDB_STEAM_APPS***REMOVED***.update({
                    _id: parseInt(id***REMOVED***
                ***REMOVED***, item.data, {
                    upsert: true
                ***REMOVED***, function(err, count***REMOVED*** {
                    return null;
                ***REMOVED******REMOVED******REMOVED***;
              ***REMOVED*** else {
                  _results1.push(void 0***REMOVED***;
              ***REMOVED***
            ***REMOVED***
              return _results1;
          ***REMOVED***;
        ***REMOVED******REMOVED***(this***REMOVED******REMOVED***;
          _results.push(i += batch***REMOVED***;
      ***REMOVED***
        return _results;
    ***REMOVED******REMOVED***;
  ***REMOVED***;

    SteamClient.prototype._read_app_list = function(***REMOVED*** {
      var s;
      s = this;
      return s.redis_client.GET(s.KEYS.STEAM_APPLIST_RAW, function(e, app_list_raw***REMOVED*** {
        var app, steam_apps, _i, _len, _ref;
        s.redis_client.DEL(s.KEYS.STEAM_APP_IDS***REMOVED***;
        steam_apps = JSON.parse(app_list_raw***REMOVED***;
        _ref = steam_apps.applist.apps.app;
        for (_i = 0, _len = _ref.length; _i < _len; _i++***REMOVED*** {
          app = _ref[_i];
          s.redis_client.RPUSH(s.KEYS.STEAM_APP_IDS, app.appid***REMOVED***;
      ***REMOVED***
        console.log("Start grabbing from Steam"***REMOVED***;
        return s._grab_data_from_steam(***REMOVED***;
    ***REMOVED******REMOVED***;
  ***REMOVED***;

    SteamClient.prototype._get_app_list = function(***REMOVED*** {
      var s;
      s = this;
      return s.redis_client.GET(s.KEYS.STEAM_APPLIST_REFRESH, function(err, steam_refresh***REMOVED*** {
        return s.redis_client.GET(s.KEYS.STEAM_APPLIST_RAW, function(e, exists***REMOVED*** {
          if (steam_refresh && exists***REMOVED*** {
            return s._read_app_list(***REMOVED***;
        ***REMOVED*** else {
            return s.unirest.get('http://api.steampowered.com/ISteamApps/GetAppList/v0001/'***REMOVED***.end((function(_this***REMOVED*** {
              return function(response***REMOVED*** {
                s.redis_client.SET(s.KEYS.STEAM_APPLIST_RAW, response.raw_body***REMOVED***;
                s.redis_client.SET(s.KEYS.STEAM_APPLIST_REFRESH, true***REMOVED***;
                s.redis_client.EXPIRE(s.KEYS.STEAM_APPLIST_REFRESH, s.opts.steam_app_cache_validity***REMOVED***;
                return s._read_app_list(***REMOVED***;
            ***REMOVED***;
          ***REMOVED******REMOVED***(this***REMOVED******REMOVED***;
        ***REMOVED***
      ***REMOVED******REMOVED***;
    ***REMOVED******REMOVED***;
  ***REMOVED***;

    return SteamClient;

***REMOVED******REMOVED***(***REMOVED***;

}***REMOVED***.call(this***REMOVED***;
