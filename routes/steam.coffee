exports.get = (req, res) ->
  steam = require("../steam")
  id = req.params.id
  if 'undefined' != typeof(id)
    res.send id
  else
    res.send "all"

exports.user_owned_games = (req, res) ->
  require("../steam")(null, (err, steam)->
    id = if req.query.id then req.query.id else req.params.id

    if 'undefined' == typeof(id)
      res.json {success: false, message: "No ID specified"}
    else
      steam.get_user_owned_games(id, (err, result)->
        if err
          res.json {success: false, message: err}
        else
          res.json result
      )
  )

exports.force_reset = (req, res) ->
  require("../steam")(null, (err, steam)->
    steam._get_app_list()
    res.json {success: true}
  )