Augury.Routers.Connections = Backbone.Router.extend(
  routes:
    "connections/new": "new"
    "connections/select": "select"
    "connections/:id/connect": "connect"
    "connections/disconnect": "disconnect"

  new: ->
    view = new Augury.Views.Connections.New()
    $("#integration_main").html view.render().el

  index: ->
    view = new Augury.Views.Connections.Index()
    $("#integration_main").html view.render().el

  select: ->
    signup = 
      auth_token: "123456"
      user: "spree@example.com"
      env: "development"
      stores: [
        { name: "Foo Store", api_url: "http://localhost:3000" },
        { name: "Foo Store 2", api_url: "http://localhost:3000" },
      ]

    view = new Augury.Views.Connections.Select signup: signup
    $("#integration_main").html view.render().el

  connect: (id) ->
    window.location.href = "/admin/integration/connect?env_id=#{id}"

  disconnect: ->
    window.location.href = "/admin/integration/disconnect"
)
