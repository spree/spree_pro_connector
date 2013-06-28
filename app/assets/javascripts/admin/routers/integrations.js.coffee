Augury.Routers.Integrations = Backbone.Router.extend(
  routes:
    "integrations": "index"
    "integrations/new": "new"
    "integrations/:id/edit": "edit"
    "integrations/:id/signup": "signup"

  index: ->
    Augury.update_nav('integrations')

    view = new Augury.Views.Integrations.Index()
    $("#integration_main").html view.render().el

  new: ->
    Augury.update_nav('integrations')

    integration = new Augury.Models.Integration
    Augury.store_integrations.add integration
    view = new Augury.Views.Integrations.Edit(model: integration)
    $("#integration_main").html view.render().el

  edit: (id) ->
    Augury.update_nav('integrations')

    integration = Augury.store_integrations.get id
    console.log integration
    view = new Augury.Views.Integrations.Edit(model: integration)
    $("#integration_main").html view.render().el

  signup: (integration_id) ->
    Augury.update_nav('integrations')

    integration = _.findWhere Augury.integrations.models,
      id: integration_id

    view = new Augury.Views.Integrations.Signup(model: integration)
    $("#integration_main").html view.render().el
)
