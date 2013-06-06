Augury.Views.Registrations.Edit = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/registrations/edit"](registration: @model)
    @$('#registration-keys.select2').select2().select2('val', @model.get('keys'))
    this
)
