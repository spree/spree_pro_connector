Augury.Models.Integration = Backbone.Model.extend(
  urlRoot: '/integrations'

  toJSON: ->
    @attributes = _.omit(@attributes, 'id')
    debugger
    return integration: _(@attributes).clone()

  use: (parameters) ->
    $.ajax
      url: "/integrations/#{@.id}/signup"
      type: 'POST'
      data:
        store_id: Augury.store_id
        parameters: parameters
      success: (registrations, response, opts)=>
        _(registrations).each (reg) ->
          Augury.registrations.add new Augury.Models.Registration(reg)

        Backbone.history.navigate "registrations/filter/#{@.id}", trigger: true
      failure: =>
        console.log 'something went wrong'
)
