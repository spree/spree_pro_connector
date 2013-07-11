Augury.Views.Parameters.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs
    @currentValue = ""
    @listTemplate = JST['admin/templates/parameters/list_fields']
    @keyValueTemplate = JST['admin/templates/parameters/key_value_fields']
    @defaultTemplate = JST['admin/templates/parameters/default_fields']

  events:
    'click button#save': 'save'
    'click button#cancel': 'cancel'
    'change :input': 'changed'
    'focusout :input': 'validate'

  render: ->
    @$el.html JST["admin/templates/parameters/edit"](parameter: @model)
    Backbone.Validation.bind @

    @prepareForm()
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

  prepareForm: ->
    unless @listTypeSelected()
      @currentValue = $(@).find('#parameter-value').val()
    @setupEventHandlers()
    @setupClickHandlers()

  setupEventHandlers: ->
    @$('#parameter-data-type').change (e) =>
      console.log "FOO"
      if @listTypeSelected()
        @showListFields()
      else
        @showDefaultFields()
    $(@).submit (e) =>
      if @listTypeSelected()
        @buildValues()

  showDefaultFields: ->


  setupClickHandlers: ->
    $(@).on 'click', '.add-key-value-pair', (e) =>
      $(e.currentTarget).closest('.list-item').append(@keyValueTemplate())
      false
    $(@).on 'click', '.remove-key-value-pair', (e) =>
      $(e.currentTarget).closest('.list-value').remove()
      false
    $(@).on 'click', '.add-value', (e) =>
      $(@).find('.list-item:last').after(@listTemplate())
      false

  listTypeSelected: ->
    $(@).find('#parameter-data-type').val() == 'list'
)
