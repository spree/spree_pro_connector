Augury.Views.Integrations.Use = Backbone.View.extend(
  events:
    'click button#save': 'save'

  render: ->
    @params = _.map(@model.get("consumers"), (consumer) ->
      consumer["requires"]["parameters"]
    )
    @params = _.uniq(_.flatten(@params), false, (x) ->
      x["name"]
    )

    @$el.html JST["admin/templates/integrations/use"]
      integration: @model
      parameters: @params

    #@$el.find('.icon_link[title]').powerTip()
    this

  save: ->
    parameters = {}

    _(@params).each (param) ->
      val = $("[name='#{param['name']}']").val()
      if val?
        parameters[param['name']] = val
      else
        console.log('missing')

    @model.use(parameters)
)
