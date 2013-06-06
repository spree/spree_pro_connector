Augury.Routers.Registrations = Backbone.Router.extend(
  routes:
    "registrations": "index"
    "registrations/:id/edit": "edit"

  index: ->
    new Augury.Collections.Registrations().fetch
      error: (a,b,c,d) ->
        console.log('err', a,b,c,d)
      success: (registrations, response, options) ->
        view = new Augury.Views.Registrations.Index(collection: registrations)
        $("#integration_main").html view.render().el

  edit: (id) ->
    new Augury.Models.Registration(id: id).fetch
      success: (registration, response, options) -> 
        view = new Augury.Views.Registrations.Edit(model: registration)
        $("#integration_main").html view.render().el
)
