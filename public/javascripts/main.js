***REMOVED***
(function(***REMOVED*** {
  $(document***REMOVED***.ready(function(***REMOVED*** {
    var ajax_loader, fn_compare_array_field, grid;
    ajax_loader = $("#ajax_loader"***REMOVED***;
    fn_compare_array_field = function(field***REMOVED*** {
      return function(a, b***REMOVED*** {
        if ("undefined" !== typeof a[field]***REMOVED*** {
          if ("undefined" !== typeof b[field]***REMOVED*** {
            return a[field].join(***REMOVED***.localeCompare(b[field].join(***REMOVED******REMOVED***;
        ***REMOVED*** else {
            return 1;
        ***REMOVED***
      ***REMOVED*** else {
          if ("undefined" !== typeof b[field]***REMOVED*** {
            return -1;
        ***REMOVED*** else {
            return 0;
        ***REMOVED***
      ***REMOVED***
    ***REMOVED***;
  ***REMOVED***;
    window.vM = new kendo.observable({
      steam_id: null,
      games_dS: new kendo.data.DataSource({
        pageSize: 50,
        serverPaging: false,
        serverFiltering: false,
        requestEnd: function(e***REMOVED*** {
          return console.log(e***REMOVED***;
      ***REMOVED***,
        transport: {
          dataType: 'json',
          read: {
            url: 'steam/user_owned_games/',
            data: function(e***REMOVED*** {
              return {
                id: vM.steam_id
            ***REMOVED***;
          ***REMOVED***
        ***REMOVED***
      ***REMOVED***,
        schema: {
          data: 'games',
          total: 'in_db_count'
      ***REMOVED***
    ***REMOVED******REMOVED***,
      steam_id_keypress: function(e***REMOVED*** {
        if (e.which === 13***REMOVED*** {
          return this.getDetails_clicked(***REMOVED***;
      ***REMOVED***
    ***REMOVED***,
      getDetails_clicked: function(***REMOVED*** {
        ajax_loader.fadeIn(***REMOVED***;
        return grid.data("kendoGrid"***REMOVED***.dataSource.read(***REMOVED***;
    ***REMOVED***
  ***REMOVED******REMOVED***;
    grid = $("#games_grid"***REMOVED***.kendoGrid({
      dataSource: vM.games_dS,
      autoBind: false,
      filterable: true,
      sortable: true,
      resizable: true,
      dataBound: function(***REMOVED*** {
        return ajax_loader.fadeOut(***REMOVED***;
    ***REMOVED***,
      pageable: {
        pageSizes: [25, 50, 100, 200, 500, 1000, 2000],
        pageSize: 50,
        input: true
    ***REMOVED***,
      columns: [
        {
          field: "id",
          title: " ",
          width: 167,
          template: kendo.template($("#app_image_template"***REMOVED***.html(***REMOVED******REMOVED***,
          sortable: false,
          filterable: false
      ***REMOVED***, {
          field: "name",
          title: "Name",
          template: kendo.template($("#app_name_template"***REMOVED***.html(***REMOVED******REMOVED***
      ***REMOVED***, {
          field: "developers",
          title: "Developers",
          width: 180,
          template: kendo.template($("#app_developers_template"***REMOVED***.html(***REMOVED******REMOVED***,
          sortable: {
            compare: fn_compare_array_field('developers'***REMOVED***
        ***REMOVED***
      ***REMOVED***, {
          field: "publishers",
          title: "Publisher",
          width: 180,
          template: kendo.template($("#app_publishers_template"***REMOVED***.html(***REMOVED******REMOVED***,
          sortable: {
            compare: fn_compare_array_field('publishers'***REMOVED***
        ***REMOVED***
      ***REMOVED***, {
          field: "metacritic.score",
          title: "Metacritic",
          width: 120,
          template: kendo.template($("#app_metacritic_template"***REMOVED***.html(***REMOVED******REMOVED***,
          sortable: {
            compare: function(a, b***REMOVED*** {
              if ("undefined" === typeof a.metacritic***REMOVED*** {
                if ("undefined" === typeof b.metacritic***REMOVED*** {
                  return 0;
              ***REMOVED*** else {
                  return -1;
              ***REMOVED***
            ***REMOVED*** else if ("undefined" === typeof b.metacritic***REMOVED*** {
                return 1;
            ***REMOVED*** else {
                return a.metacritic.score - b.metacritic.score;
            ***REMOVED***
          ***REMOVED***
        ***REMOVED***
      ***REMOVED***, {
          field: "playtime_forever",
          title: "Playtime",
          template: kendo.template($("#app_playtime_template"***REMOVED***.html(***REMOVED******REMOVED***
      ***REMOVED***
      ]
  ***REMOVED******REMOVED***;
    return kendo.bind($("#main"***REMOVED***, vM***REMOVED***;
***REMOVED******REMOVED***;

}***REMOVED***.call(this***REMOVED***;
