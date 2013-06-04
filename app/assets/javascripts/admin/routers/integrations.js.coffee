Augury.Routers.Integrations = Backbone.Router.extend(
  routes:
    "services": "index"

  index: ->
    console.log 'fetchin'
    new Augury.Collections.Integrations().fetch 
      error: (a,b,c,d) ->
        console.log('err', a,b,c,d)
      success: ->
        console.log('collection')
        #view = new Augury.Views.Integrations.Index(integrations: collection)
        #$("#integration_main").html view.render().el
        #collection
)
