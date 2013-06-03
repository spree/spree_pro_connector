window.Augury =
  init: ->
    @Routers._active['home'] = new this.Routers.Home()
    Backbone.history.start()

  Models: {}
  Collections: {}
  Routers: { _active: {} }
  Views: { Home: {} }

