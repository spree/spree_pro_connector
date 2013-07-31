Augury.Views.Home.AddIntegration = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs
    @model = attrs.integration
    @options.parametersByConsumer = @parametersByConsumer()

  events:
    'click button#save': 'save'

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

    @

  parametersByConsumer: ->
    @ret = {}

    _.map(@model.get("consumers"), (consumer) =>
      @ret[consumer["name"]] = consumer["requires"]["parameters"]
    )
    @ret

  save: (event) ->
    event.preventDefault()
    console.log 'Saving...'

    parameters = {}
    _(@$el.find('input.param')).each (param) ->
      param = $(param)
      val = param.val()
      if val?
        parameters[param.attr('name')] = val
      else
        console.log('missing')

    # enabled = $(".enabled:checked").map ->
    #   $(@).val()

    @model.signup parameters, 'import', error: @displayErrors
)
