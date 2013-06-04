Augury.Routers.Integrations = Backbone.Router.extend(
  routes:
    "services": "index"
    "registrations": "registrations"

  index: ->
    new Augury.Collections.Integrations().fetch
      error: (a,b,c,d) ->
        console.log('err', a,b,c,d)
      success: (integrations, response, options) ->
        view = new Augury.Views.Integrations.Index(collection: integrations)
        $("#integration_main").html view.render().el

  registrations: ->
    new Augury.Collections.Registrations().fetch
      error: (a,b,c,d) ->
        console.log('err', a,b,c,d)
      success: (registrations, response, options) ->
        view = new Augury.Views.Registrations.Index(collection: registrations)
        $("#integration_main").html view.render().el
        registrations
)
