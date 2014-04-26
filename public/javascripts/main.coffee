$(document).ready ()->
  ajax_loader = $("#ajax_loader")
  err_message = $("#err_message")
  clear_error = ()->
    err_message.html("")
  display_error = (title, message)->
    template =
    """
    <div class="alert alert-dismissable alert-danger">
      <button type="button" class="close" data-dismiss="alert">×</button>
      <strong>#{title}</strong><br/>
      #{message}
    </div>
    """
    clear_error()
    err_message.append($(template))

  fn_compare_array_field = (field)->
    return (a, b)->
      if "undefined" != typeof(a[field])
        if "undefined" != typeof(b[field])
          return a[field].join().localeCompare b[field].join()
        else
          return 1
      else
        return if "undefined" != typeof(b[field]) then -1 else 0

  window.vM = new kendo.observable(
    steam_id: null
    games_dS: new kendo.data.DataSource(
      pageSize: 50
      serverPaging: false
      serverFiltering: false
      transport:
        dataType: 'json'
        read:
          url: 'steam/user_owned_games/'
          data: (e)->
            return {id: vM.steam_id.trim()}
      schema:
        data: (response)->
          if response.games
            for game in response.games #data filtering
              game.score = if "undefined" != typeof(game.metacritic) then game.metacritic.score else -1
              game.developers_human = if "undefined" != typeof(game.developers) then game.developers.join(", ") else ""
              game.publishers_human = if "undefined" != typeof(game.publishers) then game.publishers.join(", ") else ""
            return response.games
          else
            display_error("Error occurred", response.message)
            return []
        total: 'in_db_count'
        model:
          id: '_id'
          fields:
            'score':
              type: "number"
            'playtime_forever':
              type: "number"
    )
    steam_id_keypress: (e)->
      if(e.which == 13)
        this.getDetails_clicked()
    getDetails_clicked: ()->
      ajax_loader.fadeIn()
      clear_error()
      grid.data("kendoGrid").dataSource.read()
  )
  grid = $("#games_grid").kendoGrid({
    dataSource: vM.games_dS
    autoBind: false
    filterable: true
    sortable: true
    resizable: true
    dataBound: ()->
      ajax_loader.fadeOut()
    pageable:
      pageSizes: [25, 50, 100, 200, 500, 1000, 2000]
      pageSize: 50
      input: true
    columns: [
      {
        field: "id"
        title: " "
        width: 167
        template: kendo.template($("#app_image_template").html())
        sortable: false
        filterable: false
      }
      {
        field: "name"
        title: "Name"
        template: kendo.template($("#app_name_template").html())
      }
      {
        field: "developers_human"
        title: "Developers"
        width: 180
        template: kendo.template($("#app_developers_template").html())
#        sortable:
#          compare: fn_compare_array_field('developers')
      }
      {
        field: "publishers_human"
        title: "Publisher"
        width: 180
        template: kendo.template($("#app_publishers_template").html())
#        sortable:
#          compare: fn_compare_array_field('publishers')
      }
      {
        field: "score"
        title: "Metacritic"
        width: 120
        template: kendo.template($("#app_metacritic_template").html())
#        sortable:
#          compare: (a, b)->
#            if "undefined" == typeof(a.metacritic)
#              return if "undefined" == typeof(b.metacritic) then 0 else -1
#            else if "undefined" == typeof(b.metacritic)
#              return 1
#            else
#              return a.metacritic.score - b.metacritic.score
      }
      {
        field: "playtime_forever"
        title: "Playtime"
        template: kendo.template($("#app_playtime_template").html())
      }
    ]

  })
  kendo.bind $("#main"), vM