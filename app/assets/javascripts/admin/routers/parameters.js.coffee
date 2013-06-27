Augury.Routers.Parameters = Backbone.Router.extend(
  initialize: (options) ->
    @collection = options.collection

  routes:
    "parameters": "index"
    "parameters/new": "new"
    "parameters/:id/edit": "edit"
    "parameters/delete/:id?confirm=:confirm": "delete"

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
    parameter = @collection.get(id)
    if confirm != 'true'
      dialog = JST['admin/templates/shared/confirm_delete']
      $.modal(dialog(klass: 'parameters', warning: 'Are you sure you want to delete this parameter?', identifier: id))
    else
      $.modal.close()
      parameter.destroy()
      @collection.remove parameter
      Backbone.history.navigate '/parameters', trigger: true
      Augury.Flash.notice "The parameter has been deleted."
)
