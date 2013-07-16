Augury.Views.Mappings.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs

  events:
    'click button#save': 'save'
    'click button#cancel': 'cancel'
    'change :input': 'changed'
    'focusout :input': 'validate'

  render: ->
    @$el.html JST["admin/templates/mappings/edit"](mapping: @model, parameters: @options.parameters, keys: @options.keys)
    Backbone.Validation.bind @
    @prepareClickHandlers()
    @prepareForm()

    $('#content-header').find('.page-title').text(if @model.isNew() then 'New Mapping' else 'Edit Mapping')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/mappings/back_button"]

    @

  save: (e) ->
    e.preventDefault()
    @buildEventKey()
    @buildEventDetails()
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

  buildEventKey: ->
    eventKey = new Object()
    $.each @$('.event-keys .event-fields'), (index, value) =>
      name = @$(value).find('input#name').first().val()
      path = @$(value).find('input#path').first().val()
      if path && name
        eventKey[name] = path
    eventKeyJSON = JSON.stringify(eventKey)
    @$('.event-keys').append("<input id='mapping-event-key' name='event-key' type='hidden' value='#{eventKeyJSON}' />")
    @model.set(event_key: @$('input[name=event-key]').val())

  buildEventDetails: ->
    eventDetails = new Object()
    $.each @$('.event-details .event-fields'), (index, value) =>
      name = @$(value).find('input#name').first().val()
      path = @$(value).find('input#path').first().val()
      if path && name
        eventDetails[name] = path
    eventDetailsJSON = JSON.stringify(eventDetails)
    @$('.event-details').append("<input id='mapping-event-details' name='event-details' type='hidden' value='#{eventDetailsJSON}' />")
    @model.set(event_details: @$('input[name=event-details]').val())

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
    @$el.on 'click', '.add-event-fields', (event) ->
      event.preventDefault()
      template = JST['admin/templates/mappings/event_fields']
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
    @$('#mapping-keys.select2').select2().select2(
      'val',
      @model.get('keys')
    )
    @$('#mapping-parameters.select2').select2().select2('val', @model.get('parameters'))
    _.each @$('.filters .row'), (row) ->
      $(row).find('select option').filter( ->
        $(@).val() == $(row).data('operator')
      ).attr('selected', true)
)
