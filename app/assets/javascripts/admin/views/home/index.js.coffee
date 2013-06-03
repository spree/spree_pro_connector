Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->

  render: ->
    @$el.html JST["admin/templates/home/index"]()
    this
)
