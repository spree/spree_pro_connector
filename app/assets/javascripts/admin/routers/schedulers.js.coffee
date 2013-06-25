Augury.Routers.Schedulers = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection

  routes:
    "schedulers": "index"

  index: (integration_id) ->
    Augury.update_nav('schedulers')

    schedulers = @collection

    view = new Augury.Views.Schedulers.Index(collection: schedulers)
    $("#integration_main").html view.render().el
)
