Augury.Routers.Connections = Backbone.Router.extend(
  routes:
    "connections/new": "new"
    "connections/:id/connect": "connect"
    "connections/disconnect": "disconnect"

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

  disconnect: ->
    window.location.href = "/admin/integration/disconnect"
)
