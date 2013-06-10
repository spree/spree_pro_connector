Augury.Routers.Integrations = Backbone.Router.extend(
  routes:
    "integrations": "index",
    "integrations/:id/use": "use"

  index: ->
    view = new Augury.Views.Integrations.Index(collection: Augury.integrations)
    $("#integration_main").html view.render().el

  use: ->
    view = new Augury.Views.Integrations.Use(model: null)
    $("#integration_main").html view.render().el
)
