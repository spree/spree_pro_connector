Augury.Routers.Integrations = Backbone.Router.extend(
  routes:
    "integrations": "index",
    "integrations/:id/signup": "signup"

  index: ->
    Augury.update_nav('integrations')

    view = new Augury.Views.Integrations.Index()
    $("#integration_main").html view.render().el

  signup: (integration_id) ->
    Augury.update_nav('integrations')

    integration = _.findWhere Augury.integrations.models,
      id: integration_id

    view = new Augury.Views.Integrations.Signup(model: integration)
    $("#integration_main").html view.render().el
)
