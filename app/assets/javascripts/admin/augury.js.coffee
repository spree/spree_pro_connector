window.Augury =
  init: ->
    $.ajaxPrefilter (options, originalOptions, jqXHR) ->
      options.url = "http://aug-stg1.spree.mx/api#{options.url}"
      options.xhrFields = withCredentials: true

    @store_id = $("#integration_main").data("store-id")

    @Routers._active['home'] = new this.Routers.Home()
    @Routers._active['integrations'] = new this.Routers.Integrations()
    @Routers._active['registrations'] = new this.Routers.Registrations()

    @handle_link_clicks()

    Backbone.history.start pushState: true, root: '/admin/integration/'

  Models: {}
  Collections: {}
  Routers: { _active: {} }
  Views: { Home: {}, Integrations: {}, Registrations: {} }

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
