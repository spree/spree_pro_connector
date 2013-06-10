Augury.Views.Integrations.Use = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/integrations/use"](integration: @model)
    #@$el.find('.icon_link[title]').powerTip()
    this

)
