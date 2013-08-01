Augury.Models.Integration = Backbone.Model.extend(
  initialize: ->
    @urlRoot = "/stores/#{Augury.store_id}/integrations"

  validation:
    name:
      required: true
      msg: "Name is required"
    url:
      required: true
      msg: "URL is required"
    category:
      required: true
      msg: "Category is required"

  toJSON: ->
    @attributes = _.omit(@attributes, 'id')
    return integration: _(@attributes).clone()

  signup: (parameters, enabled, options={}) ->
    $.post("/stores/#{Augury.store_id}/integrations/#{@.id}/signup",
      store_id: Augury.store_id
      parameters: parameters
      enabled: enabled).
      done((mappings, textStatus, jqXHR) =>
        Augury.parameters.fetch()

        _(mappings).each (mapping) ->
          existing = Augury.mappings.findWhere(name: mapping['name'])
          if existing?
            Augury.mappings.remove existing
          Augury.mappings.add new Augury.Models.Mapping(mapping)

        $.ajax
          url: "/stores/#{Augury.store_id}/integrations/#{@.id}/disable_mappings"
          type: "GET"
          success: ->
            Augury.integrations.fetch(reset: true)
          error: ->
            Augury.Flash.error "There was a problem updating the integration."

      ).fail((jqXHR, textStatus, errorThrown) =>
        # options.errors is displayErrors: (model, xhr, options)
        options.error(null, jqXHR, options) if options.error
      )

  mappings: ->
    Augury.mappings.where(integration_id: @id)

  enableMappings: ->
    defer = $.Deferred()
    $.ajax
      url: "/stores/#{Augury.store_id}/integrations/#{@.id}/enable_mappings"
      type: "GET"
      success: ->
        defer.resolve(true)
      error: ->
    defer.promise()

  disableMappings: ->
    defer = $.Deferred()
    $.ajax
      url: "/stores/#{Augury.store_id}/integrations/#{@.id}/disable_mappings"
      type: "GET"
      success: ->
        defer.resolve(true)
      error: ->
    defer.promise()

  is_enabled: ->
    mappings = @['attributes']['mappings']
    _(mappings).any (mapping) ->
      mapping['enabled'] == true
)
