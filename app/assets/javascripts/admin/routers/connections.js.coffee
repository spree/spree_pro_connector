Augury.Routers.Connections = Backbone.Router.extend(
  routes:
    "connections": "index"
    "connections/new": "new"
    "connections/:id/connect": "connect"
    "connections/:id/disconnect": "disconnect"

  new: ->
    Augury.update_nav('overview')

    view = new Augury.Views.Connections.New()
    $("#integration_main").html view.render().el

  index: ->
    Augury.update_nav('connections')

    view = new Augury.Views.Connections.Index()
    $("#integration_main").html view.render().el

  connect: (id) ->
    window.location.href = "/admin/integration/connect?env_id=#{id}"

  disconnect: (id) ->
    window.location.href = "/admin/integration/disconnect"
)
