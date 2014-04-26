***REMOVED***
(function(***REMOVED*** {
  $(document***REMOVED***.ready(function(***REMOVED*** {
    var ajax_loader, clear_error, display_error, err_message, fn_compare_array_field, grid;
    ajax_loader = $("#ajax_loader"***REMOVED***;
    err_message = $("#err_message"***REMOVED***;
    clear_error = function(***REMOVED*** {
      return err_message.html(""***REMOVED***;
  ***REMOVED***;
    display_error = function(title, message***REMOVED*** {
      var template;
      template = "<div class=\"alert alert-dismissable alert-danger\">\n  <button type=\"button\" class=\"close\" data-dismiss=\"alert\">×</button>\n  <strong>" + title + "</strong><br/>\n  " + message + "\n</div>";
      clear_error(***REMOVED***;
      return err_message.append($(template***REMOVED******REMOVED***;
  ***REMOVED***;
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
        transport: {
          dataType: 'json',
          read: {
            url: 'steam/user_owned_games/',
            data: function(e***REMOVED*** {
              return {
                id: vM.steam_id.trim(***REMOVED***
            ***REMOVED***;
          ***REMOVED***
        ***REMOVED***
      ***REMOVED***,
        schema: {
          data: function(response***REMOVED*** {
            var game, _i, _len, _ref;
            if (response.games***REMOVED*** {
              _ref = response.games;
              for (_i = 0, _len = _ref.length; _i < _len; _i++***REMOVED*** {
                game = _ref[_i];
                game.score = "undefined" !== typeof game.metacritic ? game.metacritic.score : -1;
                game.developers_human = "undefined" !== typeof game.developers ? game.developers.join(", "***REMOVED*** : "";
                game.publishers_human = "undefined" !== typeof game.publishers ? game.publishers.join(", "***REMOVED*** : "";
            ***REMOVED***
              return response.games;
          ***REMOVED*** else {
              display_error("Error occurred", response.message***REMOVED***;
              return [];
          ***REMOVED***
        ***REMOVED***,
          total: 'in_db_count',
          model: {
            id: '_id',
            fields: {
              'score': {
                type: "number"
            ***REMOVED***,
              'playtime_forever': {
                type: "number"
            ***REMOVED***
          ***REMOVED***
        ***REMOVED***
      ***REMOVED***
    ***REMOVED******REMOVED***,
      steam_id_keypress: function(e***REMOVED*** {
        if (e.which === 13***REMOVED*** {
          return this.getDetails_clicked(***REMOVED***;
      ***REMOVED***
    ***REMOVED***,
      getDetails_clicked: function(***REMOVED*** {
        ajax_loader.fadeIn(***REMOVED***;
        clear_error(***REMOVED***;
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
          field: "developers_human",
          title: "Developers",
          width: 180,
          template: kendo.template($("#app_developers_template"***REMOVED***.html(***REMOVED******REMOVED***
      ***REMOVED***, {
          field: "publishers_human",
          title: "Publisher",
          width: 180,
          template: kendo.template($("#app_publishers_template"***REMOVED***.html(***REMOVED******REMOVED***
      ***REMOVED***, {
          field: "score",
          title: "Metacritic",
          width: 120,
          template: kendo.template($("#app_metacritic_template"***REMOVED***.html(***REMOVED******REMOVED***
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
