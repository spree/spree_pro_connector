Augury.Models.Registration = Backbone.Model.extend(
  initialize: ->
    @urlRoot = "/stores/#{Augury.store_id}/registrations"

  validation:
    name:
      required: true
      msg: "Name is required"
    url:
      required: true
      msg: "URL is required"
    token:
      required: true
      msg: "Token is required"
    keys:
      required: true
      msg: "At least one key is required"

  toJSON: ->
    @attributes = _.omit(@attributes, ['id', 'formatted_filters', 'undefined'])
    return registration: _(@attributes).clone()
)
