Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->

  render: ->
    @env = _(Augury.connections).findWhere(id: Augury.env.id)

    @$el.html JST["admin/templates/home/index"](env: @env)

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.page-title').text('Overview')

    this
)
