Augury.Views.Connections.Select = Backbone.View.extend
  initialize: (options) ->
    @signup = options.signup

  events:
    "click [data-action='select']": 'select'

  render: ->
    @$el.html JST["admin/templates/connections/select"](signup: @signup)
    @

  select: (evt) ->
    evt.preventDefault()
    store_id = $(evt.target).data('store-id')
    Augury.vent.trigger 'connection:select', @signup, store_id
