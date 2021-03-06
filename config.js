// Generated by CoffeeScript 1.7.1
(function() {
  var config;

  config = {};

  config.redis_host = process.env.REDIS_HOST;

  config.redis_port = process.env.REDIS_PORT;

  config.redis_password = process.env.REDIS_PASSWORD;

  config.mongo_db_host = process.env.MONGO_DB_HOST;

  config.mongo_db_name = process.env.MONGO_DB_NAME;

  config.steam_web_api_key = process.env.STEAM_WEB_API_KEY;

  config.steam_web_api_domain = process.env.STEAM_WEB_API_DOMAIN;

  config.steam_web_api_user_api = 'http://api.steampowered.com/IPlayerService/';

  config.steam_web_api_custom_url = 'http://steamcommunity.com/id/';

  config.steam_web_api_id_url = 'http://steamcommunity.com/profiles/';

  config.steam_web_api_64_url = 'http://steamcommunity.com/profiles/';

  config.steam_app_cache_validity = 3600;

  config.steam_user_app_cache_validity = 600;

  config.n_of_app_in_query_batch = 250;

  module.exports = config;

}).call(this);
