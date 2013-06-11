Augury.Routers.Registrations = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection
    @parameters = options.parameters

  routes:
    "registrations": "index"
    "registrations/filter/:integration_id": "index"
    "registrations/new": "new"
    "registrations/:id/edit": "edit"

  index: (integration_id) ->
    if integration_id?
      registrations = @collection.byIntegration(integration_id)
    else
      registrations = @collection

    view = new Augury.Views.Registrations.Index(collection: registrations)
    $("#integration_main").html view.render().el

  new: ->
    registration = new Augury.Models.Registration
    Augury.registrations.add registration
    registration.set formatted_filters: []
    console.log registration
    view = new Augury.Views.Registrations.Edit(model: registration, parameters: @parameters, keys: Augury.keys)
    $("#integration_main").html view.render().el

  edit: (id) ->
    registration = @collection.get(id)
    view = new Augury.Views.Registrations.Edit(model: registration, parameters: @parameters, keys: Augury.keys )
    $("#integration_main").html view.render().el
)
