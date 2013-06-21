Augury.Views.Connections.Index = Backbone.View.extend

  render: ->
    @$el.html JST["admin/templates/connections/index"](connections: Augury.connections)
    @$el.find('.icon_link[title]').powerTip()
    @


