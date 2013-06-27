Augury.Routers.Parameters = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection

  routes:
    "parameters": "index"
    "parameters/new": "new"
    "parameters/:id/edit": "edit"

  index: (integration_id) ->
    Augury.update_nav('parameters')

    view = new Augury.Views.Parameters.Index()
    $("#integration_main").html view.render().el

  new: ->
    Augury.update_nav('parameters')

    parameter = new Augury.Models.Parameter
    @collection.add parameter
    view = new Augury.Views.Parameters.Edit(model: parameter)
    $("#integration_main").html view.render().el

  edit: (id) ->
    Augury.update_nav('parameters')

    parameter = @collection.get(id)
    view = new Augury.Views.Parameters.Edit(model: parameter)
    $("#integration_main").html view.render().el

  delete: (id, confirm) ->
    scheduler = @collection.get(id)
    if confirm != 'true'
      dialog = JST['admin/templates/shared/confirm_delete']
      $.modal(dialog(klass: 'schedulers', warning: 'Are you sure you want to delete this Scheduler?', identifier: id))
    else
      $.modal.close()
      scheduler.destroy()
      Augury.schedulers.remove scheduler
      Backbone.history.navigate '/schedulers', trigger: true
      Augury.Flash.notice "The scheduler has been deleted."
)
