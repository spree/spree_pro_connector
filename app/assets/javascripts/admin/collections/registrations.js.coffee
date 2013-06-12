Augury.Collections.Registrations = Backbone.Collection.extend(
  model: Augury.Models.Registration

  initialize: ->
    @url = "/stores/#{Augury.store_id}/registrations"

  byIntegration: (integration_id) ->
    new Augury.Collections.Registrations  @.filter (registration) ->
      registration.get('integration_id') == integration_id

)
