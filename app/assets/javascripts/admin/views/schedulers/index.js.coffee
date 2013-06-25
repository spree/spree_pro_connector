Augury.Views.Schedulers.Index = Backbone.View.extend(
  initialize: ->

  render: ->
    @$el.html JST["admin/templates/schedulers/index"](schedulers: @collection)
    @
)
