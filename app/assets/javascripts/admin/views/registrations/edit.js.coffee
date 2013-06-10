Augury.Views.Registrations.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs

  events:
    'click button#save': 'save'
    'change :input': 'changed'
    'change .event-keys': 'validateEventKey'

  render: ->
    @$el.html JST["admin/templates/registrations/edit"](registration: @model, parameters: @options.parameters, keys: @options.keys)
    @prepareClickHandlers()
    @validateEventKey()
    @$('#registration-keys.select2').select2().select2('val', @model.get('keys'))
    @$('#registration-parameters.select2').select2().select2('val', @model.get('parameters'))
    @

  save: (e) ->
    e.preventDefault()
    @buildEventKey()
    @buildEventDetails()
    @model.save {}, success: @saved

  saved: ->
    console.log "Model updated! ", @model

  buildEventKey: ->
    eventKey = new Object()
    jQuery.each $('.event-keys .row'), (index, value) ->
      name = $(value).find('input#name').first().val()
      path = $(value).find('input#path').first().val()
      if path && name
        eventKey[name] = path
    eventKeyJSON = JSON.stringify(eventKey)
    $('.event-keys').append("<input id='registration-event-key' name='event-key' type='hidden' value='#{eventKeyJSON}' />")
    @model.set(event_key: @$('input[name=event-key]').val())

  buildEventDetails: ->
    eventDetails = new Object()
    jQuery.each $('.event-details .row'), (index, value) ->
      name = $(value).find('input#name').first().val()
      path = $(value).find('input#path').first().val()
      if path && name
        eventDetails[name] = path
    eventDetailsJSON = JSON.stringify(eventDetails)
    $('.event-details').append("<input id='registration-event-details' name='event-details' type='hidden' value='#{eventDetailsJSON}' />")
    @model.set(event_details: @$('input[name=event-details]').val())

  prepareClickHandlers: ->
    $(@$el).on 'click', '.add-event-fields', (event) ->
      event.preventDefault()
      template = JST['admin/templates/registrations/event_fields']
      $(template()).insertAfter($(@).context)
    $(@$el).on 'click', '.remove-fields', (event) ->
      event.preventDefault()
      $(@).closest('.row').remove()

  validateEventKey: ->
    @$('.event-keys').on 'change', (event) ->
      console.log "Changed"
      inputs = $(@).find('input#name')
      input_values = _.map inputs, (input) ->
        return $(input).val()
      input_values = _.reject input_values, (value) ->
        value.length < 1
      unique_input_values = _.uniq input_values
      if unique_input_values.length != input_values.length
        $('#save')[0].disabled = true
        $(@).find('strong').after('<p class="text-error">Names must be unique</p>')
      else
        $('#save')[0].disabled = false
        $(@).find('p.text-error').remove()
)
