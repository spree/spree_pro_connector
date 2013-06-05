Augury.Views.Integrations.Index = Backbone.View.extend(
  events:
    "click .icon-link": "use"

  initialize: ->

  render: ->
    @$el.html JST["admin/templates/integrations/index"](integrations: @collection)
    @$el.find('.icon_link[title]').powerTip()
    this

  use: ->
    console.log 'use it'
)
