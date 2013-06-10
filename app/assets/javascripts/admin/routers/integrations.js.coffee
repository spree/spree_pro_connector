Augury.Routers.Integrations = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection

  routes:
    "integrations": "index",
    "integrations/:id/use": "use"

  index: ->
    view = new Augury.Views.Integrations.Index(collection: Augury.integrations)
    $("#integration_main").html view.render().el

  use: ->
    view = new Augury.Views.Integrations.Use(model: null)
    view = new Augury.Views.Integrations.Index(collection: @collection)
    $("#integration_main").html view.render().el
)
