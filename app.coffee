express = require('express')
routes = require('./routes')
steam_route = require('./routes/steam')
http = require('http')
path = require('path')
app = express()
config = require('./config')

# all environments

steam = require('./steam')(
  redis_host: config.redis_host
  redis_port: config.redis_port
  redis_password: config.redis_password
  mongo_db_host: config.mongo_db_host
  mongo_db_name: config.mongo_db_name
  steam_web_api_key: config.steam_web_api_key
  steam_web_api_domain: config.steam_web_api_domain
  steam_web_api_user_api: config.steam_web_api_user_api
  steam_web_api_custom_url: config.steam_web_api_custom_url
  steam_web_api_id_url: config.steam_web_api_id_url
  steam_web_api_64_url: config.steam_web_api_64_url
  steam_app_cache_validity: config.steam_app_cache_validity
  steam_user_app_cache_validity: config.steam_user_app_cache_validity
  n_of_app_in_query_batch: config.n_of_app_in_query_batch
)

#console.dir "A"

app.set('port', process.env.PORT || 3000)
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')
app.use(express.favicon())
app.use(express.logger('dev'))
app.use(express.json())
app.use(express.urlencoded())
app.use(express.methodOverride())
app.use(express.cookieParser('your secret here'))
app.use(express.session())
app.use(app.router)
app.use(require('stylus').middleware(path.join(__dirname, 'public')))
app.use(express.static(path.join(__dirname, 'public')))

# development only
if ('development' == app.get('env'))
  app.use(express.errorHandler())

app.get('/', routes.index)
app.get('/steam/user_owned_games/:id', steam_route.user_owned_games)
app.get('/steam/user_owned_games', steam_route.user_owned_games)
app.get('/steam/get/:id', steam_route.get)
app.get('/steam/get', steam_route.get)
app.get('/steam/force_reset', steam_route.force_reset)

http.createServer(app).listen app.get('port'), () ->
  console.log 'Express server listening on port ' + app.get('port')
