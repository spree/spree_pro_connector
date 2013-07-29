Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->

  render: ->
    @env = _(Augury.connections).findWhere(id: Augury.env.id)

    @collection = Augury.store_integrations.add(Augury.global_integrations.models)
    # Remove integrations from the collections that don't have any mappings
    @collection = @collection.remove _(@collection.models).reject (integration) ->
      !_(integration.get('mappings')).isEmpty()

    @$el.html JST["admin/templates/home/index"](
      env: @env
      collection: @collection
    )

    $('#content-header .container .block-table').append('<div class="table-cell"><ul class="page-actions"></ul></div>');
    $('#content-header').find('.page-actions').html JST["admin/templates/home/new_integration"]

    $('#content-header').find('.page-title').text('Overview')

    this
)
