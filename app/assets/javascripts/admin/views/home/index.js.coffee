Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->

  render: ->
    @env = _(Augury.connections).findWhere(id: Augury.env.id)

    @collection = Augury.store_integrations.add(Augury.global_integrations.models)

    @$el.html JST["admin/templates/home/index"](
      env: @env
      collection: @collection
    )

    $('#content-header .container .block-table').append('<div class="table-cell"><ul class="page-actions"></ul></div>');
    $('#content-header').find('.page-actions').html JST["admin/templates/home/new_integration"]

    $('#content-header').find('.page-title').text('Overview')

    this
)
