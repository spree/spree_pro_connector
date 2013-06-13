Augury.Views.Registrations.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs

  events:
    'click button#save': 'save'
    'click button#cancel': 'cancel'
    'change :input': 'changed'
    'change .event-keys': 'validateEventKey'

  render: ->
    @$el.html JST["admin/templates/registrations/edit"](registration: @model, parameters: @options.parameters, keys: @options.keys)
    @prepareClickHandlers()
    @prepareForm()
    @validateEventKey()
    @

  save: (e) ->
    e.preventDefault()
    @buildEventKey()
    @buildEventDetails()
    @buildFilters()
    @model.save {}, success: @saved

  cancel: (e) ->
    e.preventDefault()
    Backbone.history.navigate '/registrations', trigger: true

  saved: ->
    console.log "Model updated! ", @model

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
        filter.compare = {}
        filter.compare[operator] = value
        filters.push(filter)
    filtersJSON = JSON.stringify(filters)
    console.log filtersJSON
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
    @$('#registration-keys.select2').select2().select2('val', @model.get('keys'))
    @$('#registration-parameters.select2').select2().select2('val', @model.get('parameters'))
    _.each @$('.filters .row'), (row) ->
      $(row).find('select option').filter( ->
        $(@).val() == $(row).data('operator')
      ).attr('selected', true)

  validateEventKey: ->
    @$('.event-keys').on 'change', (event) =>
      console.log "Changed"
      inputs = @$el.find('input#name')
      input_values = _.map inputs, (input) ->
        return $(input).val()
      input_values = _.reject input_values, (value) ->
        value.length < 1
      unique_input_values = _.uniq input_values
      if unique_input_values.length != input_values.length
        $('#save')[0].disabled = true
        @$el.find('strong').after('<p class="text-error">Names must be unique</p>')
      else
        $('#save')[0].disabled = false
        @$el.find('p.text-error').remove()
)
