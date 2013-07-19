Augury.Models.Mapping = Backbone.Model.extend(
  initialize: ->
    @urlRoot = "/stores/#{Augury.store_id}/mappings"

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
    messages:
      required: true
      msg: "At least one message is required"

  toJSON: ->
    @attributes = _.omit(@attributes, ['id', 'formatted_filters', 'undefined'])
    return mapping: _(@attributes).clone()
)
