$(document***REMOVED***.ready (***REMOVED***->
  ajax_loader = $("#ajax_loader"***REMOVED***
  err_message = $("#err_message"***REMOVED***
  clear_error = (***REMOVED***->
    err_message.html(""***REMOVED***
  display_error = (title, message***REMOVED***->
    template =
    """
    <div class="alert alert-dismissable alert-danger">
      <button type="button" class="close" data-dismiss="alert">×</button>
      <strong>#{title}</strong><br/>
      #{message}
    </div>
    """
    clear_error(***REMOVED***
    err_message.append($(template***REMOVED******REMOVED***

  fn_compare_array_field = (field***REMOVED***->
    return (a, b***REMOVED***->
      if "undefined" != typeof(a[field]***REMOVED***
        if "undefined" != typeof(b[field]***REMOVED***
          return a[field].join(***REMOVED***.localeCompare b[field].join(***REMOVED***
        else
          return 1
      else
        return if "undefined" != typeof(b[field]***REMOVED*** then -1 else 0

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
          data: (e***REMOVED***->
            return {id: vM.steam_id.trim(***REMOVED***}
      schema:
        data: (response***REMOVED***->
          if response.games
            for game in response.games #data filtering
              game.score = if "undefined" != typeof(game.metacritic***REMOVED*** then game.metacritic.score else -1
              game.developers_human = if "undefined" != typeof(game.developers***REMOVED*** then game.developers.join(", "***REMOVED*** else ""
              game.publishers_human = if "undefined" != typeof(game.publishers***REMOVED*** then game.publishers.join(", "***REMOVED*** else ""
            return response.games
          else
            display_error("Error occurred", response.message***REMOVED***
            return []
        total: 'in_db_count'
        model:
          id: '_id'
          fields:
            'score':
              type: "number"
            'playtime_forever':
              type: "number"
    ***REMOVED***
    steam_id_keypress: (e***REMOVED***->
      if(e.which == 13***REMOVED***
        this.getDetails_clicked(***REMOVED***
    getDetails_clicked: (***REMOVED***->
      ajax_loader.fadeIn(***REMOVED***
      clear_error(***REMOVED***
      grid.data("kendoGrid"***REMOVED***.dataSource.read(***REMOVED***
  ***REMOVED***
  grid = $("#games_grid"***REMOVED***.kendoGrid({
    dataSource: vM.games_dS
    autoBind: false
    filterable: true
    sortable: true
    resizable: true
    dataBound: (***REMOVED***->
      ajax_loader.fadeOut(***REMOVED***
    pageable:
      pageSizes: [25, 50, 100, 200, 500, 1000, 2000]
      pageSize: 50
      input: true
    columns: [
      {
        field: "id"
        title: " "
        width: 167
        template: kendo.template($("#app_image_template"***REMOVED***.html(***REMOVED******REMOVED***
        sortable: false
        filterable: false
    ***REMOVED***
      {
        field: "name"
        title: "Name"
        template: kendo.template($("#app_name_template"***REMOVED***.html(***REMOVED******REMOVED***
    ***REMOVED***
      {
        field: "developers_human"
        title: "Developers"
        width: 180
        template: kendo.template($("#app_developers_template"***REMOVED***.html(***REMOVED******REMOVED***
#        sortable:
#          compare: fn_compare_array_field('developers'***REMOVED***
    ***REMOVED***
      {
        field: "publishers_human"
        title: "Publisher"
        width: 180
        template: kendo.template($("#app_publishers_template"***REMOVED***.html(***REMOVED******REMOVED***
#        sortable:
#          compare: fn_compare_array_field('publishers'***REMOVED***
    ***REMOVED***
      {
        field: "score"
        title: "Metacritic"
        width: 120
        template: kendo.template($("#app_metacritic_template"***REMOVED***.html(***REMOVED******REMOVED***
#        sortable:
#          compare: (a, b***REMOVED***->
#            if "undefined" == typeof(a.metacritic***REMOVED***
#              return if "undefined" == typeof(b.metacritic***REMOVED*** then 0 else -1
#            else if "undefined" == typeof(b.metacritic***REMOVED***
#              return 1
#            else
#              return a.metacritic.score - b.metacritic.score
    ***REMOVED***
      {
        field: "playtime_forever"
        title: "Playtime"
        template: kendo.template($("#app_playtime_template"***REMOVED***.html(***REMOVED******REMOVED***
    ***REMOVED***
    ]

***REMOVED******REMOVED***
  kendo.bind $("#main"***REMOVED***, vM