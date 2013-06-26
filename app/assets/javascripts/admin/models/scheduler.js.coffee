Augury.Models.Scheduler = Backbone.Model.extend(
  initialize: ->
    @urlRoot = "/stores/#{Augury.store_id}/schedulers"

  validation:
    count:
      required: true
      msg: "Count is required"
    interval:
      required: true
      msg: "Interval is required"

  toJSON: ->
    @attributes = _.omit(@attributes, ['id', 'undefined'])
    return scheduler: _(@attributes).clone()
)
