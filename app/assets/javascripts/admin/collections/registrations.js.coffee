Augury.Collections.Registrations = Backbone.Collection.extend(
  model: Augury.Models.Registration

  initialize: ->
    @url = "/stores/#{Augury.store_id}/registrations"
)
