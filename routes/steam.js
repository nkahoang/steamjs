***REMOVED***
(function(***REMOVED*** {
  exports.get = function(req, res***REMOVED*** {
    var id, steam;
    steam = require("../steam"***REMOVED***;
    id = req.params.id;
    if ('undefined' !== typeof id***REMOVED*** {
      return res.send(id***REMOVED***;
  ***REMOVED*** else {
      return res.send("all"***REMOVED***;
  ***REMOVED***
***REMOVED***;

  exports.user_owned_games = function(req, res***REMOVED*** {
    return require("../steam"***REMOVED***(null, function(err, steam***REMOVED*** {
      var id;
      id = req.query.id ? req.query.id : req.params.id;
      if ('undefined' === typeof id***REMOVED*** {
        return res.json({
          success: false,
          message: "No ID specified"
      ***REMOVED******REMOVED***;
    ***REMOVED*** else {
        return steam.get_user_owned_games(id, function(err, result***REMOVED*** {
          if (err***REMOVED*** {
            return res.json({
              success: false,
              message: err
          ***REMOVED******REMOVED***;
        ***REMOVED*** else {
            return res.json(result***REMOVED***;
        ***REMOVED***
      ***REMOVED******REMOVED***;
    ***REMOVED***
  ***REMOVED******REMOVED***;
***REMOVED***;

  exports.force_reset = function(req, res***REMOVED*** {
    return require("../steam"***REMOVED***(null, function(err, steam***REMOVED*** {
      steam._get_app_list(***REMOVED***;
      return res.json({
        success: true
    ***REMOVED******REMOVED***;
  ***REMOVED******REMOVED***;
***REMOVED***;

}***REMOVED***.call(this***REMOVED***;
