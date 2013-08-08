Augury.Views.Connections.Select = Backbone.View.extend
  initialize: (options) ->
    @signup = options.signup

  events:
    "click [data-action='select']": 'select'

  render: ->
    @$el.html JST["admin/templates/connections/select"](signup: @signup)

    $('#content-header').find('.page-title').text('Select Store')

    @

  select: (evt) ->
    evt.preventDefault()
    store_id = $(evt.target).parent().data('store-id')
    Augury.vent.trigger 'connection:select', @signup, store_id
