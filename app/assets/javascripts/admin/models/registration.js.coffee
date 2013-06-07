Augury.Models.Registration = Backbone.Model.extend(
  initialize: ->
    @urlRoot = "/stores/#{Augury.store_id}/registrations"

  toJSON: ->
    @attributes = _.omit(@attributes, 'id')
    return registration: _(@attributes).clone()
)
