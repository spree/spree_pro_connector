Augury.Routers.Home = Backbone.Router.extend(
  routes:
    "": "index"

  index: ->
    Augury.update_nav('overview')

    view = new Augury.Views.Home.Index()
    $("#integration_main").html view.render().el
)
