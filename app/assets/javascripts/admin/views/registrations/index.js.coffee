Augury.Views.Registrations.Index = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/registrations/index"](registrations: Augury.registrations)
    @
)
