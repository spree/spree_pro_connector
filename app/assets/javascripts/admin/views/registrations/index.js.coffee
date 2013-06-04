Augury.Views.Registrations.Index = Backbone.View.extend(
  initialize: ->

  render: ->
    @$el.html JST["admin/templates/registrations/index"](registrations: @collection)
    this
)
