config = {}

# Redis host, port and AUTH details to cache Steam IDs list, cache user query, etc

config.redis_host = ''
config.redis_port = 11414
config.redis_password = '' # null if there is no password
config.redis_use_ENV = true #if true, use ENV instead of config file

# Mongo connection string
# Format: db_user:db_pass@host:port
config.mongo_db_host = ''
config.mongo_db_name = '' #database name
config.mongo_use_ENV = true #if true, use ENV instead of config file

# Steam web API key and domain, obtained by registering at
# http://steamcommunity.com/dev/apikey
config.steam_web_api_key= ''
config.steam_web_api_domain= ''
config.steam_web_api_ENV = true #if true, use ENV instead of config file

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