Augury.Routers.Home = Backbone.Router.extend(
  routes:
    "": "index"
    "add/:id": "addIntegration"

  index: ->
    Augury.update_nav('overview')

    view = new Augury.Views.Home.Index()
    $("#integration_main").html view.render().el

  addIntegration: (id) ->
    view = new Augury.Views.Home.AddIntegration()
    view.render()
)
