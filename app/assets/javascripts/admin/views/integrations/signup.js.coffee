Augury.Views.Integrations.Signup = Backbone.View.extend(
  events:
    'click button#save': 'save'
    "change input[name='enabled']": 'toggle_enabled_consumers'

  render: ->
    @$el.html JST["admin/templates/integrations/signup"]
      integration: @model
      parameters_by_consumer: @parameters_by_consumer()

    @$el.find('input.param').bind "keyup paste", ->
      current = $(@)

      duplicates = $("[name='#{current.attr('name')}']")
      if duplicates.length > 1
        duplicates.val(current.val())

    @toggle_enabled_consumers()

    $('#content-header').find('.page-title').text(@model.get('display') + ' Setup')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/integrations/back_button"]

    @

  parameters_by_consumer: ->
    @ret = {}

    _.map(@model.get("consumers"), (consumer) =>
      @ret[consumer["name"]] = consumer["requires"]["parameters"]
    )
    @ret

  toggle_enabled_consumers: ->
    for consumer_name,parameters of @parameters_by_consumer()
      checked = @$el.find("input[value='#{consumer_name}']").is ':checked'
      if checked
        @$el.find("input.#{consumer_name}").removeAttr 'disabled'
      else
        @$el.find("input.#{consumer_name}").attr 'disabled', true


  save: ->
    parameters = {}

    _($('input.param')).each (param) ->
      param = $(param)
      val = param.val()
      if val?
        parameters[param.attr('name')] = val
      else
        console.log('missing')

    enabled = $(".enabled:checked").map ->
      $(@).val()

    @model.signup parameters, enabled.get(), error: @displayErrors
)
