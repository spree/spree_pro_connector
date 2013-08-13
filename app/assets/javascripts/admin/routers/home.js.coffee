Augury.Routers.Home = Backbone.Router.extend(
  routes:
    "": "index"
    "add/:id": "addIntegration"
    "edit/:id": "addIntegration"
    "refresh/:id": "refreshIntegration"
    "delete/:id?confirm=:confirm": "delete"

  index: ->
    Augury.update_nav('overview')

    view = new Augury.Views.Home.Index(collection: Augury.integrations)
    $("#integration_main").html view.render().el

  delete: (id, confirm) ->
    integration = Augury.integrations.get id
    if confirm != 'true'
      dialog = JST['admin/templates/shared/confirm_delete']
      $.modal(dialog(klass: 'integration', warning: 'Are you sure you want to delete this integration?', identifier: id))
    else
      $.modal.close()
      integration.destroy()
      Augury.mappings.fetch
        reset: true
        success: (results) ->
          Augury.integrations.remove integration
          Augury.integrations.fetch reset: true
          Backbone.history.navigate '/'
          Augury.Flash.success "The integration has been deleted."
)
