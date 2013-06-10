Augury.Routers.Registrations = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection
    @parameters = options.parameters

  routes:
    "registrations": "index"
    "registrations/:id/edit": "edit"

  index: ->
    view = new Augury.Views.Registrations.Index(collection: @collection)
    $("#integration_main").html view.render().el

  edit: (id) ->
    registration = @collection.get(id)
    view = new Augury.Views.Registrations.Edit(model: registration, parameters: @parameters, keys: Augury.keys )
    $("#integration_main").html view.render().el
)
