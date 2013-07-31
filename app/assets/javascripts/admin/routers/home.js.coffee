Augury.Routers.Home = Backbone.Router.extend(
  routes:
    "": "index"
    "add/:id": "addIntegration"

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
    console.log view.el
    modalEl.modal(
      closeHTML: "<i class=\"icon-remove\"></i>"
      minHeight: 500
      minWidth: 860
      persist: true
      onClose: (dialog) ->
        $.modal.close()
        $("#integrations-select").select2 "val", ""
        $("#new-integration-modal").html('')
        Backbone.history.navigate '/', trigger: true
    )
)
