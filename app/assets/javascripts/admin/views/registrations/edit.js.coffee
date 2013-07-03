Augury.Views.Registrations.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs

  events:
    'click button#save': 'save'
    'click button#cancel': 'cancel'
    'change :input': 'changed'
    'focusout :input': 'validate'

  render: ->
    @$el.html JST["admin/templates/registrations/edit"](registration: @model, parameters: @options.parameters, keys: @options.keys)
    Backbone.Validation.bind @
    @prepareClickHandlers()
    @prepareForm()

    $('#content-header').find('.page-title').text(if @model.isNew() then 'New Registrations' else 'Edit Registrations')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/registrations/back_button"]

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
      Augury.registrations.remove @model
    Backbone.history.navigate '/registrations', trigger: true

  saved: ->
    Augury.Flash.success "The registration has been successfully saved."

  buildEventKey: ->
    eventKey = new Object()
    $.each @$('.event-keys .event-fields'), (index, value) =>
      name = @$(value).find('input#name').first().val()
      path = @$(value).find('input#path').first().val()
      if path && name
        eventKey[name] = path
    eventKeyJSON = JSON.stringify(eventKey)
    @$('.event-keys').append("<input id='registration-event-key' name='event-key' type='hidden' value='#{eventKeyJSON}' />")
    @model.set(event_key: @$('input[name=event-key]').val())

  buildEventDetails: ->
    eventDetails = new Object()
    $.each @$('.event-details .event-fields'), (index, value) =>
      name = @$(value).find('input#name').first().val()
      path = @$(value).find('input#path').first().val()
      if path && name
        eventDetails[name] = path
    eventDetailsJSON = JSON.stringify(eventDetails)
    @$('.event-details').append("<input id='registration-event-details' name='event-details' type='hidden' value='#{eventDetailsJSON}' />")
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
    @$('.filters').append("<input id='registration-filters' name='filters' type='hidden' value='#{filtersJSON}' />")
    @model.set(filters: @$('input[name=filters]').val())

  prepareClickHandlers: ->
    @$el.on 'click', '.add-event-fields', (event) ->
      event.preventDefault()
      template = JST['admin/templates/registrations/event_fields']
      $(template()).insertAfter($(@).context)
    @$el.on 'click', '.remove-fields', (event) ->
      event.preventDefault()
      $(@).closest('.row').remove()
    @$el.on 'click', '.add-filter-fields', (event) ->
      event.preventDefault()
      template = JST['admin/templates/registrations/filter_fields']
      $(template()).insertAfter($(@).context)

  prepareForm: ->
    @$('#registration-keys.select2').select2().select2(
      'val',
      @model.get('keys')
    )
    @$('#registration-parameters.select2').select2().select2('val', @model.get('parameters'))
    _.each @$('.filters .row'), (row) ->
      $(row).find('select option').filter( ->
        $(@).val() == $(row).data('operator')
      ).attr('selected', true)
)
