Augury.Collections.Parameters = Backbone.Collection.extend(
  model: Augury.Models.Parameter
  initialize: ->
    @url = "/stores/#{Augury.store_id}/parameters"

  byName: (name) ->
    @.findWhere name: name

  valueByName: (name) ->
    param = @byName(name)
    if param?
      param.get('value')
    else
      null
)
