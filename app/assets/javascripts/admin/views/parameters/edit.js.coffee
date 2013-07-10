Augury.Views.Parameters.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs

  events:
    'click button#save': 'save'
    'click button#cancel': 'cancel'
    'change :input': 'changed'
    'focusout :input': 'validate'

  render: ->
    @$el.html JST["admin/templates/parameters/edit"](parameter: @model)
    Backbone.Validation.bind @

    @$('#parameter-data-type').val @model.get('data_type')
    @$('#parameter-data-type').select2()

    $('#content-header').find('.page-title').text(if @model.isNew() then 'New Parameter' else 'Edit Parameter')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/parameters/back_button"]

    @

  save: (e) ->
    e.preventDefault()
    @model.validate()
    if @model.isValid()
      @model.save {}, success: @saved, error: @displayErrors

  cancel: (e) ->
    e.preventDefault()
    if @model.isNew()
      Augury.parameters.remove @model
    Backbone.history.navigate '/parameters', trigger: true

  saved: ->
    Augury.Flash.success "The parameter has been successfully saved."
)
