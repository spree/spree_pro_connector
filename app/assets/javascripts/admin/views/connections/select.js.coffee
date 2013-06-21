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
    window.location.href = "/admin/integration/register?url=#{Augury.url}&env=#{@signup.env}&user=#{@signup.user}&user_token=#{@signup.auth_token}&store_id=#{store_id}"

