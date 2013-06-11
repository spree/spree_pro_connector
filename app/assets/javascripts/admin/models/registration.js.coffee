Augury.Models.Registration = Backbone.Model.extend(
  initialize: ->
    @urlRoot = "/stores/#{Augury.store_id}/registrations"

  toJSON: ->
    @attributes = _.omit(@attributes, ['id', 'formatted_filters'])
    return registration: _(@attributes).clone()
)
