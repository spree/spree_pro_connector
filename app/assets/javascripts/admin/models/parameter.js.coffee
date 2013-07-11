Augury.Models.Parameter = Backbone.Model.extend(
  initialize: ->
    @urlRoot = "/stores/#{Augury.store_id}/parameters"

  defaults:
    data_type: 'string'

  validation:
    name:
      required: true
      msg: "Name is required"
    data_type:
      required: true
      msg: "Data type is required"
    value:
      required: true
      msg: "Value is required"
)
