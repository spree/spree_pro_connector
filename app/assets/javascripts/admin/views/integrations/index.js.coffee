Augury.Views.Integrations.Index = Backbone.View.extend(
  initialize: ->

  render: ->
    @$el.html JST["admin/templates/integrations/index"]()
    this
)
