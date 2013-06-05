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
    registration = new Augury.Models.Registration(id: id)
    registration.fetch()
    console.log(registration)
)
