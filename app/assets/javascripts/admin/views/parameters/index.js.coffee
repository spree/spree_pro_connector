Augury.Views.Parameters.Index = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/parameters/index"](parameters: Augury.parameters)

    $('#content-header').find('.page-title').text('Parameters')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/parameters/new_button"]

    @
)
