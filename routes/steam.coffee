exports.get = (req, res***REMOVED*** ->
  steam = require("../steam"***REMOVED***
  id = req.params.id
  if 'undefined' != typeof(id***REMOVED***
    res.send id
  else
    res.send "all"

exports.user_owned_games = (req, res***REMOVED*** ->
  require("../steam"***REMOVED***(null, (err, steam***REMOVED***->
    id = if req.query.id then req.query.id else req.params.id

    if 'undefined' == typeof(id***REMOVED***
      res.json {success: false, message: "No ID specified"}
    else
      steam.get_user_owned_games(id, (err, result***REMOVED***->
        if err
          res.json {success: false, message: err}
        else
          res.json result
      ***REMOVED***
  ***REMOVED***

exports.force_reset = (req, res***REMOVED*** ->
  require("../steam"***REMOVED***(null, (err, steam***REMOVED***->
    steam._get_app_list(***REMOVED***
    res.json {success: true}
  ***REMOVED***