config = {}

# Redis host, port and AUTH details to cache Steam IDs list, cache user query, etc
config.redis_host = 'pub-redis-11414.us-east-1-3.3.ec2.garantiadata.com'
config.redis_port = 11414
config.redis_password = 'redisSteam' # null if there is no password

# Mongo connection string
# Format: db_user:db_pass@host:port
config.mongo_db_host = 'steam_node:steamNode@ds037478.mongolab.com:37478'
config.mongo_db_name = 'steamdb' #database name

# Steam web API key and domain, obtained by registering at
# http://steamcommunity.com/dev/apikey
config.steam_web_api_key= 'F2AB1C25BD33F9E4E3F743E05490CE7C'
config.steam_web_api_domain= 'nkahnt.com'

# Steam REST API Endpoint, not likely to be changed
config.steam_web_api_user_api= 'http://api.steampowered.com/IPlayerService/'
config.steam_web_api_custom_url= 'http://steamcommunity.com/id/'
config.steam_web_api_id_url= 'http://steamcommunity.com/profiles/'
config.steam_web_api_64_url= 'http://steamcommunity.com/profiles/'

# How long redis should cache Steam ID query, in second
config.steam_app_cache_validity= 3600
# How long redis should cache user query
config.steam_user_app_cache_validity= 600
# How many steam app to query in one AJAX call to Steam
config.n_of_app_in_query_batch= 250

module.exports = config;