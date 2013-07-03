Augury.Views.Schedulers.Index = Backbone.View.extend(
  initialize: ->

  render: ->
    @$el.html JST["admin/templates/schedulers/index"](schedulers: Augury.schedulers)

    $('#content-header').find('.page-title').text('Schedulers')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/schedulers/new_button"]

    @
)
