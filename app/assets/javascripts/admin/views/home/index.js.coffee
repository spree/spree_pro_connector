Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->
    _.bindAll @, 'render'
    @collection.bind 'reset', @render
    @collection.bind 'add', @render
    @collection.bind 'remove', @render

  events:
    'click .integration-toggle': 'toggleIntegration'

  render: ->
    @env = Augury.connections[Augury.env_id]

    # Filter integrations from the collection that don't have any mappings
    activeIntegrations = @collection.filter (integration) ->
      !_(integration.get('mappings')).isEmpty()
    inactiveIntegrations = @collection.filter (integration) ->
      _(integration.get('mappings')).isEmpty()

    @active = new Augury.Collections.Integrations(activeIntegrations)
    @inactive = new Augury.Collections.Integrations(inactiveIntegrations)

    @$el.html JST["admin/templates/home/index"](
      env: @env
      collection: @active
    )

    if $('#content-header .container .block-table').find('.page-actions').length < 1
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
    @$el.find('.integration-toggle').toggles
      on:    true
      width: 90
      text:
        on:  'Enabled',
        off: 'Disabled'

    @$el.find('#integrations-list').find('.actions a').powerTip
      popupId: 'integration-tooltip'

    @$el.find('#integrations-list').find('.actions a').on
      powerTipRender: () ->
        $('#integration-tooltip').addClass $(this).attr('class')


    _(@active.models).each (integration) =>
      unless integration.is_enabled()
        id = integration.get('id')
        @$el.find("*[data-integration-id=#{id}] .integration-toggle").first().trigger('toggleOff')

  toggleIntegration: (e) ->
    integrationDiv = $(e.currentTarget).closest('.integration')
    integrationId = integrationDiv.data('integration-id')
    integration = Augury.integrations.get integrationId

    if integrationDiv.hasClass 'enabled'
      integration.disableMappings().done(->
        integrationDiv.removeClass('enabled').addClass('disabled')
        Augury.integrations.fetch()
        Augury.mappings.fetch()
        @active = Augury.integrations
      ).fail(->
        Augury.Flash.error "There was a problem updating the integration."
      )
    else
      integration.enableMappings().done(->
        integrationDiv.removeClass('disabled').addClass('enabled')
        Augury.integrations.fetch()
        Augury.mappings.fetch()
        @active = Augury.integrations
      ).fail(->
        Augury.Flash.error "There was a problem updating the integration."
      )
)
