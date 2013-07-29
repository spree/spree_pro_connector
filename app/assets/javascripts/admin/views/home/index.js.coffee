Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->

  render: ->
    @env = _(Augury.connections).findWhere(id: Augury.env.id)

    @collection = Augury.store_integrations.add(Augury.global_integrations.models)

    @$el.html JST["admin/templates/home/index"](
      env: @env
      collection: @collection
    )

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.page-title').text('Overview')

    this
)
