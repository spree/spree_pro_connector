Augury.Views.Home.AddIntegration = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs
    @model = attrs.integration
    @options.parametersByConsumer = @parametersByConsumer()
    @enabledMappings = []
    @keyValueTemplate = JST['admin/templates/parameters/key_value_fields']
    @listTemplate = JST['admin/templates/parameters/list_fields']

  events:
    'click button#save': 'save'
    'click button#cancel': 'cancel'

  render: ->
    # Show modal
    @$el.html JST["admin/templates/home/modal"](options: @options)

    # Setup modal tabs
    @$el.find("#modal-tabs").tabs().addClass("ui-tabs-vertical ui-helper-clearfix")
    @$el.find("#modal-tabs li").removeClass("ui-corner-top").addClass("ui-corner-left")


    # Copy text across duplicate inputs across consumers
    @$el.find('input.param').bind "keyup paste", ->
      current = $(@)
      duplicates = $("[name='#{current.attr('name')}']")
      if duplicates.length > 1
        duplicates.val(current.val())

    # Prepare consumer state toggle
    @$el.find('.integration-toggle').toggles({
      text: {
        on: 'Enabled', 
        off: 'Disabled' 
      },
      on: true,
      width: 90
    })

    # Handle clicking on consumer state toggles
    @$el.find('.integration-toggle').on 'toggle', (event, active) =>
      if active
        @model.enableMappings()
      else
        @model.disableMappings()

    @listClickHandlers()

    @

  listClickHandlers: ->
    @$el.on 'click', '.add-new-row', (e) =>
      $(@keyValueTemplate()).appendTo($(e.currentTarget).prevUntil('.div.field').first())
      false

    @$el.on 'click', '.remove-row', (e) =>
      $(e.currentTarget).closest('.list-row').remove()
      false

    @$el.on 'click', '.add-new-value', (e) =>
      @$el.find('.list-item:last').after(@listTemplate())
      false

  parametersByConsumer: ->
    @ret = {}

    _.map(@model.get("consumers"), (consumer) =>
      @ret[consumer["name"]] = consumer["requires"]["parameters"]
    )
    @ret

  buildValues: (e) ->
    _($('fieldset.list-value')).each (fieldset) =>
      finalValue = []
      paramName = $(fieldset).data('parameter-name')
      _($(fieldset).find('.list-item')).each (value) =>
        currentValue = new Object()
        _($(value).find('.list-row')).each (element) ->
          key = $(element).find('input[name=key]').val()
          value = $(element).find('input[name=value]').val()
          console.log key, value
          if key && value
            currentValue[key] = value
        finalValue.push currentValue
      finalValueJSON = JSON.stringify(finalValue)
      @$el.append("<input class='parameter_value' name='#{paramName}' type='hidden' value='#{finalValueJSON}' />")
    console.log @$el.find('input.parameter_value')

  save: (event) ->
    event.preventDefault()

    @buildValues()

    parameters = {}
    _(@$el.find('input.param')).each (param) ->
      param = $(param)
      val = param.val()
      if val?
        parameters[param.attr('name')] = val
      else
        console.log('missing')

    if @$el.find('input.parameter_value').length > 0
      _(@$el.find('input.parameter_value')).each (param) ->
        param = $(param)
        val = param.val()
        if val?
          parameters[param.attr('name')] = val
        else
          console.log 'missing'

    # _(@$el.find('input.enabled')).each (enabled) ->
    #   enabled = $(enabled)

    # enabled = $(".enabled:checked").map ->
    #   $(@).val()
    #
    # for consumerName of @parametersByConsumer()
    #   @enabledMappings.push consumerName

    @model.signup parameters, @enabledMappings, error: @displayErrors
    $.modal.close()

  cancel: (event) ->
    event.preventDefault()

    $.modal.close()
)
