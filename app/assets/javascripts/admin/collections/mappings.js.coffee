Augury.Collections.Mappings = Backbone.Collection.extend(
  model: Augury.Models.Mapping

  initialize: ->
    @url = "/stores/#{Augury.store_id}/mappings"

  byIntegration: (integration_id) ->
    new Augury.Collections.Mappings  @.filter (mapping) ->
      mapping.get('integration_id') == integration_id

)
