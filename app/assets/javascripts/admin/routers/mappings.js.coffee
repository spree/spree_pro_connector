Augury.Routers.Mappings = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection
    @parameters = options.parameters

  routes:
    "mappings": "index"
    "mappings/filter/:integration_id": "index"
    "mappings/new": "new"
    "mappings/:id/edit": "edit"
    "mappings/delete/:id?confirm=:confirm": "delete"

  index: (integration_id) ->
    Augury.update_nav('mappings')

    if integration_id?
      mappings = @collection.byIntegration(integration_id)
    else
      mappings = @collection

    view = new Augury.Views.Mappings.Index()
    $("#integration_main").html view.render().el

  new: ->
    Augury.update_nav('mappings')

    mapping = new Augury.Models.Mapping
    Augury.mappings.add mapping
    mapping.set filters: []
    mapping.set options: retries_allowed: false
    view = new Augury.Views.Mappings.Edit(model: mapping, parameters: @parameters, messages: Augury.messages)
    $("#integration_main").html view.render().el

  edit: (id) ->
    Augury.update_nav('mappings')

    mapping = @collection.get(id)
    view = new Augury.Views.Mappings.Edit(model: mapping, parameters: @parameters, messages: Augury.messages )
    $("#integration_main").html view.render().el

  delete: (id, confirm) ->
    mapping = @collection.get(id)
    if confirm != 'true'
      dialog = JST['admin/templates/shared/confirm_delete']
      $.modal(dialog(klass: 'mappings', warning: 'Are you sure you want to delete this Mapping?', identifier: id))
    else
      $.modal.close()
      mapping.destroy()
      Augury.mappings.remove(mapping)
      Backbone.history.navigate '/mappings', trigger: true
      Augury.Flash.notice "The mapping has been deleted."
)
