Augury.Views.Registrations.Index = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/registrations/index"](registrations: Augury.registrations)

    $('#content-header').find('.page-title').text('Registrations')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/registrations/new_button"]

    @
)
