***REMOVED***
(function(***REMOVED*** {
  var app, express, http, path, routes, steam, steam_route;

  ***REMOVED***;

  ***REMOVED***;

  ***REMOVED***;

  ***REMOVED***;

  ***REMOVED***;

  ***REMOVED***;

  ***REMOVED***{
    redis_host: 'pub-redis-11414.us-east-1-3.3.ec2.garantiadata.com',
    redis_port: 11414,
    redis_password: 'redisSteam',
    mongo_db_host: 'steam_node:steamNode@ds037478.mongolab.com:37478',
    mongo_db_name: 'steamdb',
    steam_web_api_key: 'F2AB1C25BD33F9E4E3F743E05490CE7C',
    steam_web_api_domain: 'nkahnt.com',
    steam_web_api_user_api: 'http://api.steampowered.com/IPlayerService/',
    steam_web_api_custom_url: 'http://steamcommunity.com/id/',
    steam_web_api_id_url: 'http://steamcommunity.com/profiles/',
    steam_web_api_64_url: 'http://steamcommunity.com/profiles/',
    steam_app_cache_validity: 3600,
    steam_user_app_cache_validity: 600,
    n_of_app_in_query_batch: 250
***REMOVED******REMOVED***;

  app.set('port', process.env.PORT || 3000***REMOVED***;

  app.set('views', path.join(__dirname, 'views'***REMOVED******REMOVED***;

  app.set('view engine', 'jade'***REMOVED***;

  app.use(express.favicon(***REMOVED******REMOVED***;

  app.use(express.logger('dev'***REMOVED******REMOVED***;

  app.use(express.json(***REMOVED******REMOVED***;

  app.use(express.urlencoded(***REMOVED******REMOVED***;

  app.use(express.methodOverride(***REMOVED******REMOVED***;

  app.use(express.cookieParser('your secret here'***REMOVED******REMOVED***;

  app.use(express.session(***REMOVED******REMOVED***;

  app.use(app.router***REMOVED***;

  app.use(require('stylus'***REMOVED***.middleware(path.join(__dirname, 'public'***REMOVED******REMOVED******REMOVED***;

  app.use(express["static"](path.join(__dirname, 'public'***REMOVED******REMOVED******REMOVED***;

  if ('development' === app.get('env'***REMOVED******REMOVED*** {
    app.use(express.errorHandler(***REMOVED******REMOVED***;
***REMOVED***

  app.get('/', routes.index***REMOVED***;

  app.get('/steam/user_owned_games/:id', steam_route.user_owned_games***REMOVED***;

  app.get('/steam/user_owned_games', steam_route.user_owned_games***REMOVED***;

  app.get('/steam/get/:id', steam_route.get***REMOVED***;

  app.get('/steam/get', steam_route.get***REMOVED***;

  app.get('/steam/force_reset', steam_route.force_reset***REMOVED***;

  http.createServer(app***REMOVED***.listen(app.get('port'***REMOVED***, function(***REMOVED*** {
    return console.log('Express server listening on port ' + app.get('port'***REMOVED******REMOVED***;
***REMOVED******REMOVED***;

}***REMOVED***.call(this***REMOVED***;
