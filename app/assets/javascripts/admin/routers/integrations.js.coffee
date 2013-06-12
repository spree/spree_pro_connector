Augury.Routers.Integrations = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection

  routes:
    "integrations": "index",
    "integrations/:id/use": "use"

  index: ->
    view = new Augury.Views.Integrations.Index(collection: @collection)
    $("#integration_main").html view.render().el

  use: (integration_id) ->
    integration = _.findWhere Augury.integrations.models,
      id: integration_id

    view = new Augury.Views.Integrations.Use(model: integration)
    $("#integration_main").html view.render().el
)
