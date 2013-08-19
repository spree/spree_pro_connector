Augury.Views.Home.Index = Backbone.View.extend(
  initialize: ->
    _.bindAll @, 'render'
    @collection.bind 'reset', @render

  events:
    'click .integration-toggle': 'toggleIntegration'
    'click .edit-integration': 'editIntegration'
    'click .refresh-integration': 'refreshIntegration'

  render: ->
    @env = Augury.connections[Augury.env_id]

    # Filter integrations from the collection that don't have any mappings
    activeIntegrations = @collection.filter (integration) ->
      !_(integration.mappings()).isEmpty()
    inactiveIntegrations = @collection.filter (integration) ->
      _(integration.mappings()).isEmpty()

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

    # Append connection select dropdown
    @$el.find('#connection-actions').html JST["admin/templates/home/select_connection"](connections: Augury.connections)

    $('#content-header').find('.page-title').text('Overview')


    $("#integrations-select").on "select2-selected", (event, object) =>
      selected = $("#integrations-select").select2('data').element
      integrationId = $(selected).data('integration-id')
      @showIntegrationModal(integrationId)

    @$el.find("#connections-select").on "select2-selected", (event, object) =>
      selected = $("#connections-select").select2('data').element
      connectionId = $(selected).val()
      if connectionId == 'new-connection'
        Backbone.history.navigate '/connections/new', trigger: true
      else
        Augury.vent.trigger 'connection:change', connectionId

    @setActiveIntegrations()

    this

  editIntegration: (e) ->
    e.preventDefault()
    integrationId = $(e.currentTarget).closest('li.integration').data('integration-id')
    @showIntegrationModal(integrationId)

  showIntegrationModal: (integrationId) ->
    integration = Augury.integrations.get(integrationId)
    view = new Augury.Views.Home.AddIntegration(integration: integration)
    view.render()
    modalEl = $("#new-integration-modal")
    modalEl.html(view.el)
    modalEl.dialog(
      dialogClass: 'new-integration-modal dialog-integration'
      draggable: false
      resizable: false
      modal: true
      minHeight: 400
      minWidth: 865
      show: 'fade'
      hide: 'fade'

      open: () -> 
        $('body').css('overflow', 'hidden')

      close: () ->
        $('body').css('overflow', 'auto')
        $("#integrations-select").select2 "val", ""
        $("#new-integration-modal").html('')
    )

  refreshIntegration: (e) ->
    e.preventDefault()
    Augury.integrations.fetch(reset: true)
    Augury.mappings.fetch(reset: true)
    Augury.Flash.success "Refreshed integration."

  setActiveIntegrations: ->
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
