Augury.Collections.Schedulers = Backbone.Collection.extend(
  model: Augury.Models.Scheduler

  initialize: ->
    @url = "/stores/#{Augury.store_id}/schedulers"
)
