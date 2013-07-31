Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->

  events:
    'click .integration-toggle': 'toggleIntegration'

  render: ->
    @env = _(Augury.connections).findWhere(id: Augury.env.id)

    # Filter integrations from the collection that don't have any mappings
    activeIntegrations = Augury.integrations.filter (integration) ->
      !_(integration.get('mappings')).isEmpty()
    inactiveIntegrations = Augury.integrations.filter (integration) ->
      _(integration.get('mappings')).isEmpty()

    @active = new Augury.Collections.Integrations(activeIntegrations)
    @inactive = new Augury.Collections.Integrations(inactiveIntegrations)

    @$el.html JST["admin/templates/home/index"](
      env: @env
      collection: @active
    )

    $('#content-header .container .block-table').append('<div class="table-cell"><ul class="page-actions"></ul></div>')
    $('#content-header').find('.page-actions').html JST["admin/templates/home/new_integration"]
      collection: @inactive

    $('#content-header').find('.page-title').text('Overview')


    $("#integrations-select").on "select2-selected", (event, object) =>
      selected = $("#integrations-select").select2('data').element
      integrationID = $(selected).data('integration-id')
      Backbone.history.navigate "/add/#{integrationID}", trigger: true

    @setActiveIntegrations()

    this

  setActiveIntegrations: ->
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
    _(@active.models).each (integration) =>
      unless integration.is_enabled()
        id = integration.get('id')
        @$el.find("*[data-integration-id=#{id}] .integration-toggle").first().trigger('toggleOff')

  toggleIntegration: (e) ->
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
          @active = Augury.integrations
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
          @active = Augury.integrations
        error: ->
          Augury.Flash.error "There was a problem updating the integration."
)
