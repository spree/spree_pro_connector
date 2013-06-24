Augury.Routers.Registrations = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection
    @parameters = options.parameters

  routes:
    "registrations": "index"
    "registrations/filter/:integration_id": "index"
    "registrations/new": "new"
    "registrations/:id/edit": "edit"
    "registrations/delete/:id?confirm=:confirm": "delete"

  index: (integration_id) ->
    Augury.update_nav('registrations')

    if integration_id?
      registrations = @collection.byIntegration(integration_id)
    else
      registrations = @collection

    view = new Augury.Views.Registrations.Index(collection: registrations)
    $("#integration_main").html view.render().el

  new: ->
    Augury.update_nav('registrations')

    registration = new Augury.Models.Registration
    Augury.registrations.add registration
    registration.set filters: []
    view = new Augury.Views.Registrations.Edit(model: registration, parameters: @parameters, keys: Augury.keys)
    $("#integration_main").html view.render().el

  edit: (id) ->
    Augury.update_nav('registrations')

    registration = @collection.get(id)
    view = new Augury.Views.Registrations.Edit(model: registration, parameters: @parameters, keys: Augury.keys )
    $("#integration_main").html view.render().el

  delete: (id, confirm) ->
    registration = @collection.get(id)
    if confirm != 'true'
      dialog = JST['admin/templates/shared/confirm_delete']
      $.modal(dialog(klass: 'registrations', warning: 'Are you sure you want to delete this Registration?', identifier: id))
    else
      $.modal.close()
      registration.destroy()
      Augury.registrations.remove(registration)
      Backbone.history.navigate '/registrations', trigger: true
)
