Augury.Collections.Parameters = Backbone.Collection.extend(
  model: Augury.Models.Parameter
  initialize: ->
    @url = "/stores/#{Augury.store_id}/parameters"
)
