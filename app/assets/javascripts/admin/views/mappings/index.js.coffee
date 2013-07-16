Augury.Views.Mappings.Index = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/mappings/index"](mappings: Augury.mappings)

    $('#content-header').find('.page-title').text('Mappings')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/mappings/new_button"]

    @
)
