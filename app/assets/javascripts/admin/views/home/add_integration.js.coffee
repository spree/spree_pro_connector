Augury.Views.Home.AddIntegration = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs
    @model = attrs.integration
    @options.parametersByConsumer = @parametersByConsumer()
    @enabledMappings = []

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

    @

  parametersByConsumer: ->
    @ret = {}

    _.map(@model.get("consumers"), (consumer) =>
      @ret[consumer["name"]] = consumer["requires"]["parameters"]
    )
    @ret

  save: (event) ->
    event.preventDefault()

    parameters = {}
    _(@$el.find('input.param')).each (param) ->
      param = $(param)
      val = param.val()
      if val?
        parameters[param.attr('name')] = val
      else
        console.log('missing')

    # _(@$el.find('input.enabled')).each (enabled) ->
    #   enabled = $(enabled)

    # enabled = $(".enabled:checked").map ->
    #   $(@).val()
    #
    for consumerName of @parametersByConsumer()
      @enabledMappings.push consumerName

    @model.signup parameters, @enabledMappings, error: @displayErrors
    $.modal.close()

  cancel: (event) ->
    event.preventDefault()

    $.modal.close()
)
