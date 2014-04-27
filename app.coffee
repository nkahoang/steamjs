***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

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
