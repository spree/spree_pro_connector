Augury.Views.Parameters.Index = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/parameters/index"](parameters: Augury.parameters)
    @
)
