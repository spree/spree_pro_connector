Augury.Routers.Schedulers = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection

  routes:
    "schedulers": "index"
    "schedulers/:id/edit": "edit"

  index: (integration_id) ->
    Augury.update_nav('schedulers')

    schedulers = @collection

    view = new Augury.Views.Schedulers.Index(collection: schedulers)
    $("#integration_main").html view.render().el

  edit: (id) ->
    Augury.update_nav('schedulers')

    scheduler = @collection.get(id)
    view = new Augury.Views.Schedulers.Edit(model: scheduler, keys: Augury.keys)
    $("#integration_main").html view.render().el
)
