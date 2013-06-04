Augury.Views.Integrations.Index = Backbone.View.extend(
  initialize: (data) ->
    @integrations = data.integrations

  render: ->
    console.log(@integrations)
    @$el.html JST["admin/templates/integrations/index"](integrations: @integrations)
    this
)
