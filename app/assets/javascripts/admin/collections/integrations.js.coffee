Augury.Collections.Integrations = Backbone.Collection.extend(
  model: Augury.Models.Integration

  initialize: ->
    @url = "/stores/#{Augury.store_id}/integrations"
)
