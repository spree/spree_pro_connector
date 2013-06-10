window.Augury =
  init: ->
    $.ajaxPrefilter (options, originalOptions, jqXHR) ->
      jqXHR.setRequestHeader("X-Augury-Token", Augury.api_key)
      options.url = "#{Augury.pro_url}/api#{options.url}"
      options.xhrFields = withCredentials: true

    @integrations = new @Collections.Integrations(@Preload.integrations)
    @registrations = new @Collections.Registrations(@Preload.registrations)
    @parameters = new @Collections.Parameters(@Preload.parameters)
    @keys = @Preload.keys

    @Routers._active['home'] = new @Routers.Home()
    @Routers._active['integrations'] = new @Routers.Integrations
      collection: @integrations
    @Routers._active['registrations'] = new @Routers.Registrations
      collection: @registrations
      parameters: @parameters

    @handle_link_clicks()

    Backbone.history.start pushState: true, root: '/admin/integration/'

  Models: {}
  Collections: {}
  Routers: { _active: {} }
  Views: { Home: {}, Integrations: {}, Registrations: {} }
  Preload: {}

  handle_link_clicks: ->
    $(document).on "click", "a[href^='/admin/integration']", (event) ->

      href = $(event.currentTarget).attr('href')

      if href is '/admin/integration'
        href = ''
      else
        href = href.replace Backbone.history.root, ''

      if href.indexOf Backbone.history.root is 0
        event.preventDefault()
        Backbone.history.navigate href, trigger: true
