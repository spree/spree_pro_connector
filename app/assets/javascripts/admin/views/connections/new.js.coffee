Augury.Views.Connections.New = Backbone.View.extend
  initialize: ->

  events:
    'click button#connect': 'connect'
    'click button#cancel': 'cancel'
    'click button#login': 'login'
    "change [name='new_or_existing']": 'toggle_new_or_existing'
    "change [name='env']": 'toggle_env'

  render: ->
    @$el.html JST["admin/templates/connections/new"]()
    @$('.select2').select2(minimumResultsForSearch: 5)
    @toggle_new_or_existing()
    @toggle_env()
    @

  toggle_new_or_existing: ->
    new_or_existing = @$el.find("[name='new_or_existing']:checked").val()

    if new_or_existing=='new'
      @$el.find("#login_buttons").hide()
      @$el.find("#invite").show()
      @$el.find("#connect_buttons").show()
    else
      @$el.find("#login_buttons").show()
      @$el.find("#invite").hide()
      @$el.find("#connect_buttons").hide()

  toggle_env: ->
    env = @$el.find("[name='env']").val()
    @$el.find('#env_label').text env

    if env=='custom'
      @$el.find("p.url").hide()
      @$el.find("input.url").show()
    else
      url = @$el.find("p.url")
      url.text Augury.SignUp.urls[env]
      url.show()
      @$el.find("input.url").hide()

  cancel: ->
    window.location.href = "/admin/"

  set_url: ->
    env = @$el.find("[name='env']").val()
    if env == 'custom'
      Augury.url = @$el.find('input.url').val()
    else
      Augury.url = Augury.SignUp[env]

  login: ->
    @set_url()

    $.ajax
      url: '/login'
      type: 'POST'
      data:
        signup:
          name: @$el.find('input#name').val()
          url: @$el.find('input#url').val()
          version: @$el.find('input#version').val()
          api_key: @$el.find('input#api_key').val()
        user:
          email: @$el.find('input#email').val()
          password: @$el.find('input#password').val()

      success: (signup, response, opts)=>
        view = new Augury.Views.Connections.Select(signup: signup)
        $("#integration_main").html view.render().el

      error: (x,y,z) =>
        alert('login failed')


  connect: ->
    @set_url()

    $.ajax
      url: '/signup'
      type: 'POST'
      data:
        signup:
          name: @$el.find('input#name').val()
          url: @$el.find('input#url').val()
          version: @$el.find('input#version').val()
          api_key: @$el.find('input#api_key').val()
          email: @$el.find('input#email').val()
          password: @$el.find('input#password').val()
          invite_code: @$el.find('input#invite_code').val()

      success: (login, response, opts)=>
        window.location.href = "/admin/integration/register?url=#{Augury.url}&env=#{login.env}&user_token=#{login.auth_token}&store_id=#{login.store_id}&user=#{login.user}"
      error: (x,y,z) =>
        alert('signup failed')

