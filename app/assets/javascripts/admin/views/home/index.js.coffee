Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->

  events:
    'click .integration-toggle': 'toggle_integration'

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

    $('#content-header .container .block-table').append('<div class="table-cell"><ul class="page-actions"></ul></div>')
    $('#content-header').find('.page-actions').html JST["admin/templates/home/new_integration"]
    @$el.append JST["admin/templates/home/modal"]



    $('#content-header').find('.page-title').text('Overview')

    this

  toggle_integration: (e) ->
    integrationDiv = $(e.currentTarget).closest('.integration')
    integrationId = integrationDiv.data('integration-id')

    if integrationDiv.hasClass 'enabled'
      $.ajax
        url: "/stores/#{Augury.store_id}/integrations/#{integrationId}/disable_mappings"
        type: "GET"
        success: ->
          integrationDiv.removeClass('enabled').addClass('disabled')
          Augury.global_integrations.fetch({ data: { global: 1 } })
          @collection = Augury.global_integrations.add Augury.store_integrations.fetch().models
    else
      $.ajax
        url: "/stores/#{Augury.store_id}/integrations/#{integrationId}/enable_mappings"
        type: "GET"
        success: ->
          integrationDiv.removeClass('disabled').addClass('enabled')
          Augury.global_integrations.fetch({ data: { global: 1 } })
          @collection = Augury.global_integrations.add Augury.store_integrations.fetch().models
)
