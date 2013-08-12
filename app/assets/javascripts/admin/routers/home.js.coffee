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

  addIntegration: (id) ->
    integration = Augury.integrations.get(id)
    view = new Augury.Views.Home.AddIntegration(integration: integration)
    view.render()
    modalEl = $("#new-integration-modal")
    modalEl.html(view.el)
    modalEl.modal(
      closeHTML: "<i class=\"icon-remove\"></i>"
      maxHeight: 500
      minHeight: 400
      minWidth: 860
      overflow: 'auto'
      persist: true
      onOpen: (dialog) ->
        dialog.overlay.fadeIn 500
        dialog.container.fadeIn 500
        dialog.data.fadeIn 500

      onClose: (dialog) ->
        $.modal.close()
        $("#integrations-select").select2 "val", ""
        $("#new-integration-modal").html('')
        Backbone.history.navigate '/', trigger: true
    )

  refreshIntegration: (id) ->
    Augury.integrations.fetch(reset: true)
    Augury.mappings.fetch(reset: true)
    Augury.Flash.success "Refreshed integration."
    Backbone.history.navigate '/', trigger: true

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
