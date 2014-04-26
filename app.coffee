express = require('express')
routes = require('./routes')
steam_route = require('./routes/steam')
http = require('http')
path = require('path')
app = express()
# all environments

#app.set('redis_host', 'pub-redis-11414.us-east-1-3.3.ec2.garantiadata.com')
#app.set('redis_port', 11414)
#app.set('redis_password', 'redisSteam')
#app.set('redis_host', '127.0.0.1')
#app.set('redis_port', 6379)
#app.set('redis_password', null)

steam = require('./steam')(
  redis_host: 'pub-redis-11414.us-east-1-3.3.ec2.garantiadata.com'
  redis_port: 11414
  redis_password: 'redisSteam'
  #mongo_db_host: '192.168.1.118:27017'
  mongo_db_host: 'steam_node:steamNode@ds037478.mongolab.com:37478'
  mongo_db_name: 'steamdb'
  steam_web_api_key: 'F2AB1C25BD33F9E4E3F743E05490CE7C'
  steam_web_api_domain: 'nkahnt.com'
  steam_web_api_user_api: 'http://api.steampowered.com/IPlayerService/'
  steam_web_api_custom_url: 'http://steamcommunity.com/id/'
  steam_web_api_id_url: 'http://steamcommunity.com/profiles/'
  steam_web_api_64_url: 'http://steamcommunity.com/profiles/'
  steam_app_cache_validity: 3600
  steam_user_app_cache_validity: 600
  n_of_app_in_query_batch: 250
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
