Augury.Views.Parameters.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs
    @keyValueTemplate = JST['admin/templates/parameters/key_value_fields']
    @defaultTemplate = JST['admin/templates/parameters/default_fields']
    @listTemplate = JST['admin/templates/parameters/list_fields']
    @listValueFieldsTemplate = JST['admin/templates/parameters/list_value_fields']

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

    @prepareForm()

    if @model.get('data_type') == 'list'
      for item in @model.get('value') 
        @$('.values-container').append @listValueFieldsTemplate(item: item)

    $('#content-header').find('.page-title').text(if @model.isNew() then 'New Parameter' else 'Edit Parameter')
    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/parameters/back_button"]
    @

  save: (e) ->
    e.preventDefault()
    if @listTypeSelected()
      @buildValues()
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
    @setupEventHandlers()
    @setupClickHandlers()
    if @listTypeSelected()
      @showListFields()
    else
      @showDefaultFields()

  setupEventHandlers: ->
    @$('#parameter-data-type').change (e) =>
      if @listTypeSelected()
        @showListFields()
      else
        @model.set value: ''
        @showDefaultFields()

  showDefaultFields: ->
    @$('.value-fields-container').html @defaultTemplate(parameter: @model)

  showListFields: ->
    @$('.value-fields-container').html @listTemplate(parameter: @model)
    if typeof @model.get('value') != "object"
      @$('.values-container').append @listValueFieldsTemplate()
      @$('.list-values').append @keyValueTemplate()

  setupClickHandlers: ->
    $(document).on 'click', '.add-key-value-pair', (e) =>
      $(e.currentTarget).parent().next('.list-values').append @keyValueTemplate()
      false
    $(document).on 'click', '.remove-key-value-pair', (e) =>
      $(e.currentTarget).closest('.list-value').remove()
      false
    $(document).on 'click', '.add-value', (e) =>
      @$('.list-item:last').after @listValueFieldsTemplate()
      @$('.list-values:last').append @keyValueTemplate()
      false

  listTypeSelected: ->
    @$('#parameter-data-type').val() == 'list'

  buildValues: (e) ->
    finalValue = []
    _(@$('.list-item')).each (value) ->
      currentValue = new Object()
      _($(value).find('.list-value')).each (element) ->
        key = $(element).find('input[name=key]').val()
        value = $(element).find('input[name=value]').val()
        if key && value
          currentValue[key] = value
      if Object.keys(currentValue).length > 0
        finalValue.push currentValue
    finalValueJSON = JSON.stringify(finalValue)
    @model.set(value: finalValueJSON)
)
