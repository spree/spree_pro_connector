Augury.Views.Mappings.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs

  events:
    'click button#save': 'save'
    'click button#cancel': 'cancel'
    'change :input': 'changed'
    'focusout :input': 'validate'

  render: ->
    @$el.html JST["admin/templates/mappings/edit"](mapping: @model, parameters: @options.parameters, messages: @options.messages)
    Backbone.Validation.bind @
    @prepareClickHandlers()
    @prepareForm()

    $('#content-header').find('.page-title').text(if @model.isNew() then 'New Mapping' else 'Edit Mapping')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/mappings/back_button"]

    @

  save: (e) ->
    e.preventDefault()
    @buildIdentifiers()
    @buildFilters()
    @model.validate()
    if @model.isValid()
      @model.save {}, success: @saved, error: @displayErrors

  cancel: (e) ->
    e.preventDefault()
    if @model.isNew()
      Augury.mappings.remove @model
    Backbone.history.navigate '/mappings', trigger: true

  saved: ->
    Augury.Flash.success "The mapping has been successfully saved."

  buildIdentifiers: ->
    identifiers = new Object()
    $.each @$('.identifiers .identifier-fields'), (index, value) =>
      name = @$(value).find('input#name').first().val()
      path = @$(value).find('input#path').first().val()
      if path && name
        identifiers[name] = path
    identifiersJSON = JSON.stringify(identifiers)
    @$('.identifiers').append("<input id='mapping-identifiers' name='identifiers' type='hidden' value='#{identifiersJSON}' />")
    console.log identifiersJSON
    @model.set(identifiers: @$('input[name=identifiers]').val())

  buildFilters: ->
    filters = []
    jQuery.each $('.filters .filter-fields'), (index, value) ->
      filter = new Object()
      path = $(value).find('input#path').first().val()
      operator = $(value).find('select#operator option:selected').val()
      value = $(value).find('input#value').first().val()
      if path && operator && value
        filter.path = path
        filter.value = value
        filter.operator = operator
        filters.push(filter)
    filtersJSON = JSON.stringify(filters)
    @$('.filters').append("<input id='mapping-filters' name='filters' type='hidden' value='#{filtersJSON}' />")
    @model.set(filters: @$('input[name=filters]').val())

  prepareClickHandlers: ->
    @$el.on 'click', '.add-identifier-fields', (event) ->
      event.preventDefault()
      template = JST['admin/templates/mappings/identifier_fields']
      $(template()).insertAfter($(@).context)
    @$el.on 'click', '.remove-fields', (event) ->
      event.preventDefault()
      $(@).closest('.additional-fields').remove()
    @$el.on 'click', '.add-filter-fields', (event) ->
      event.preventDefault()
      template = JST['admin/templates/mappings/filter_fields']
      $(template()).insertAfter($(@).context)
      $('#operator').select2()

  prepareForm: ->
    @$('#mapping-messages.select2').select2().select2(
      'val',
      @model.get('messages')
    )
    @$('#mapping-parameters.select2').select2().select2('val', @model.get('parameters'))
    _.each @$('.filters .row'), (row) ->
      $(row).find('select option').filter( ->
        $(@).val() == $(row).data('operator')
      ).attr('selected', true)
)
