Augury.Views.Connections.Index = Backbone.View.extend

  render: ->
    @$el.html JST["admin/templates/connections/index"](connections: Augury.connections)
    @$el.find('.icon_link[title]').powerTip()

    $('#content-header').find('.page-title').text('Connections')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/connections/new_button"]

    @


