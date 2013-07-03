Augury.Views.Integrations.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs

  events:
    'click button#save': 'save'
    'click button#cancel': 'cancel'
    'change :input': 'changed'
    'focusout :input': 'validate'

  render: ->
    @$el.html JST["admin/templates/integrations/edit"](integration: @model)
    Backbone.Validation.bind @

    $('#content-header').find('.page-title').text(if @model.isNew() then 'New Integration' else 'Edit Integration')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/integrations/back_button"]

    @

  save: (e) ->
    e.preventDefault()
    @model.validate()
    if @model.isValid()
      @model.save {}, success: @saved, error: @displayErrors

  cancel: (e) ->
    e.preventDefault()
    if @model.isNew()
      Augury.store_integrations.remove @model
    Backbone.history.navigate '/integrations', trigger: true

  saved: ->
    Augury.Flash.success "The integration has been successfully saved."
)
