$(document***REMOVED***.ready (***REMOVED***->
  ajax_loader = $("#ajax_loader"***REMOVED***
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
      requestEnd: (e***REMOVED***->
        console.log e
      transport:
        dataType: 'json'
        read:
          url: 'steam/user_owned_games/'
          data: (e***REMOVED***->
            return {id: vM.steam_id}
      schema:
        data: 'games'
        total: 'in_db_count'
    ***REMOVED***
    steam_id_keypress: (e***REMOVED***->
      if(e.which == 13***REMOVED***
        this.getDetails_clicked(***REMOVED***
    getDetails_clicked: (***REMOVED***->
      ajax_loader.fadeIn(***REMOVED***
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
        field: "developers"
        title: "Developers"
        width: 180
        template: kendo.template($("#app_developers_template"***REMOVED***.html(***REMOVED******REMOVED***
        sortable:
          compare: fn_compare_array_field('developers'***REMOVED***
    ***REMOVED***
      {
        field: "publishers"
        title: "Publisher"
        width: 180
        template: kendo.template($("#app_publishers_template"***REMOVED***.html(***REMOVED******REMOVED***
        sortable:
          compare: fn_compare_array_field('publishers'***REMOVED***
    ***REMOVED***
      {
        field: "metacritic.score"
        title: "Metacritic"
        width: 120
        template: kendo.template($("#app_metacritic_template"***REMOVED***.html(***REMOVED******REMOVED***
        sortable:
          compare: (a, b***REMOVED***->
            if "undefined" == typeof(a.metacritic***REMOVED***
              return if "undefined" == typeof(b.metacritic***REMOVED*** then 0 else -1
            else if "undefined" == typeof(b.metacritic***REMOVED***
              return 1
            else
              return a.metacritic.score - b.metacritic.score
    ***REMOVED***
      {
        field: "playtime_forever"
        title: "Playtime"
        template: kendo.template($("#app_playtime_template"***REMOVED***.html(***REMOVED******REMOVED***
    ***REMOVED***
    ]

***REMOVED******REMOVED***
  kendo.bind $("#main"***REMOVED***, vM