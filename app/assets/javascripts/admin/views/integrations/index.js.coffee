Augury.Views.Integrations.Index = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/integrations/index"](integrations: @collection)
    @$el.find('.icon_link[title]').powerTip()
    this
)
