***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
  redis_host: if config.redis_use_ENV then process.env.REDIS_HOST else config.redis_host
  redis_port: if config.redis_use_ENV then process.env.REDIS_PORT else config.redis_port
  redis_password: if config.redis_use_ENV then process.env.REDIS_PASSWORD else config.redis_password
  mongo_db_host: if config.mongo_use_ENV then process.env.MONGO_DB_HOST else config.mongo_db_host
  mongo_db_name: if config.mongo_use_ENV then process.env.MONGO_DB_NAME else config.mongo_db_name
  steam_web_api_key: if config.steam_web_api_ENV then process.env.STEAM_WEB_API_KEY else config.steam_web_api_key
  steam_web_api_domain: if config.steam_web_api_ENV then process.env.STEAM_WEB_API_DOMAIN else config.steam_web_api_domain
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

#console.dir "A"

app.set('port', process.env.PORT || 3000***REMOVED***
app.set('views', path.join(__dirname, 'views'***REMOVED******REMOVED***
app.set('view engine', 'jade'***REMOVED***
app.use(express.favicon(***REMOVED******REMOVED***
app.use(express.logger('dev'***REMOVED******REMOVED***
app.use(express.json(***REMOVED******REMOVED***
app.use(express.urlencoded(***REMOVED******REMOVED***
app.use(express.methodOverride(***REMOVED******REMOVED***
app.use(express.cookieParser('your secret here'***REMOVED******REMOVED***
app.use(express.session(***REMOVED******REMOVED***
app.use(app.router***REMOVED***
app.use(require('stylus'***REMOVED***.middleware(path.join(__dirname, 'public'***REMOVED******REMOVED******REMOVED***
app.use(express.static(path.join(__dirname, 'public'***REMOVED******REMOVED******REMOVED***

***REMOVED***
if ('development' == app.get('env'***REMOVED******REMOVED***
  app.use(express.errorHandler(***REMOVED******REMOVED***

app.get('/', routes.index***REMOVED***
app.get('/steam/user_owned_games/:id', steam_route.user_owned_games***REMOVED***
app.get('/steam/user_owned_games', steam_route.user_owned_games***REMOVED***
app.get('/steam/get/:id', steam_route.get***REMOVED***
app.get('/steam/get', steam_route.get***REMOVED***
app.get('/steam/force_reset', steam_route.force_reset***REMOVED***

http.createServer(app***REMOVED***.listen app.get('port'***REMOVED***, (***REMOVED*** ->
  console.log 'Express server listening on port ' + app.get('port'***REMOVED***
