Augury.Models.Integration = Backbone.Model.extend(
  urlRoot: '/integrations'

  toJSON: ->
    @attributes = _.omit(@attributes, 'id')
    return integration: _(@attributes).clone()

  signup: (parameters,enabled) ->
    $.ajax
      url: "/integrations/#{@.id}/signup"
      type: 'POST'
      data:
        store_id: Augury.store_id
        parameters: parameters
        enabled: enabled
      success: (registrations, response, opts)=>
        Augury.parameters.fetch()

        _(registrations).each (reg) ->
          existing = Augury.registrations.findWhere(name: reg['name'])

          if existing?
            Augury.registrations.remove existing

          Augury.registrations.add new Augury.Models.Registration(reg)

        Backbone.history.navigate "registrations/filter/#{@.id}", trigger: true
      failure: =>
        console.log 'something went wrong'

  registrations: ->
    Augury.registrations.where(integration_id: @id)
)
