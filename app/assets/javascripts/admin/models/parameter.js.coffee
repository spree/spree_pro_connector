Augury.Models.Parameter = Backbone.Model.extend(
  initialize: ->
    @urlRoot = "/stores/#{Augury.store_id}/parameters"

  validation:
    name:
      required: true
      msg: "Name is required"
    value:
      required: true
      msg: "Value is required"
)
