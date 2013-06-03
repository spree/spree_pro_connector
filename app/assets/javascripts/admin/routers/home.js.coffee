Augury.Routers.Home = Backbone.Router.extend(
  routes:
    "": "index"

  index: ->
    $.ajaxPrefilter (options, originalOptions, jqXHR) ->
      options.url = "http://aug-stg1.spree.mx/api#{options.url}"

    view = new Augury.Views.Home.Index()

    $("#integration_main").html view.render().el
)
