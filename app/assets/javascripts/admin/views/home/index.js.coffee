Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->

  events:
    'click .integration-toggle': 'toggle_integration'

  render: ->
    @env = _(Augury.connections).findWhere(id: Augury.env.id)

    @collection = Augury.integrations
    # Remove integrations from the collection that don't have any mappings
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

    # TODO: Find a better way to do this
    @$el.find('.integration-toggle').toggles({
      text: {
        on: 'Enabled', 
        off: 'Disabled' 
      },
      on: true,
      width: 90
    })

    @$el.find('#integrations-list').find('.actions a').powerTip({
      popupId: 'integration-tooltip'
    })
    _(@collection.models).each (integration) =>
      unless integration.is_enabled()
        id = integration.get('id')
        @$el.find("*[data-integration-id=#{id}] .integration-toggle").first().trigger('toggleOff')

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
          Augury.integrations.fetch()
          Augury.mappings.fetch()
          @collection = Augury.integrations
        error: ->
          Augury.Flash.error "There was a problem updating the integration."
    else
      $.ajax
        url: "/stores/#{Augury.store_id}/integrations/#{integrationId}/enable_mappings"
        type: "GET"
        success: ->
          integrationDiv.removeClass('disabled').addClass('enabled')
          Augury.integrations.fetch()
          Augury.mappings.fetch()
          @collection = Augury.integrations
        error: ->
          Augury.Flash.error "There was a problem updating the integration."
)
