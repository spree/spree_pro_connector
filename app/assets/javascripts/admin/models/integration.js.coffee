Augury.Models.Integration = Backbone.Model.extend(
  initialize: ->
    @urlRoot = "/stores/#{Augury.store_id}/integrations"

  validation:
    name:
      required: true
      msg: "Name is required"
    url:
      required: true
      msg: "URL is required"
    category:
      required: true
      msg: "Category is required"

  toJSON: ->
    @attributes = _.omit(@attributes, 'id')
    return integration: _(@attributes).clone()

  signup: (parameters,enabled) ->
    $.ajax
      url: "/stores/#{Augury.store_id}/integrations/#{@.id}/signup"
      type: 'POST'
      data:
        store_id: Augury.store_id
        parameters: parameters
        enabled: enabled
      success: (mappings, response, opts)=>
        Augury.parameters.fetch()

        _(mappings).each (reg) ->
          existing = Augury.mappings.findWhere(name: reg['name'])

          if existing?
            Augury.mappings.remove existing

          Augury.mappings.add new Augury.Models.Mapping(reg)

        Backbone.history.navigate "mappings/filter/#{@.id}", trigger: true
      failure: =>
        console.log 'something went wrong'

  mappings: ->
    Augury.mappings.where(integration_id: @id)
)
