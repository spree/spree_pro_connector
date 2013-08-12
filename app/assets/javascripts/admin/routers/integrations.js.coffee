Augury.Routers.Integrations = Backbone.Router.extend(
  routes:
    "integrations": "index"
    "integrations/new": "new"
    "integrations/:id/edit": "edit"
    "integrations/delete/:id?confirm=:confirm": "delete"
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
    view = new Augury.Views.Integrations.Edit(model: integration)
    $("#integration_main").html view.render().el

  delete: (id, confirm) ->
    integration = Augury.store_integrations.get id
    if confirm != 'true'
      dialog = JST['admin/templates/shared/confirm_delete']
      $.modal(dialog(klass: 'integrations', warning: 'Are you sure you want to delete this integration?', identifier: id))
    else
      $.modal.close()
      integration.destroy()
      Augury.store_integrations.remove integration
      Backbone.history.navigate '/', trigger: true
      Augury.Flash.notice "The integration has been deleted."

  signup: (integration_id) ->
    Augury.update_nav('integrations')

    integration = _.findWhere Augury.global_integrations.models,
      id: integration_id

    unless integration?
      integration = _.findWhere Augury.store_integrations.models,
        id: integration_id

    view = new Augury.Views.Integrations.Signup(model: integration)
    $("#integration_main").html view.render().el
)
