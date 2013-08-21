Augury.Views.Connections.New = Backbone.View.extend
  events:
    'click button#cancel': 'cancel'

  render: ->
    @$el.html JST["admin/templates/connections/new"]()

    @form = @$el.find('#new-connection-wizard')
    @envCheck = @form.find("fieldset[data-step=\"environment\"]").find("input[type=\"radio\"]")
    @step1 = @form.find("[data-step=\"environment\"]")
    @step1_5 = @form.find("[data-step=\"integrator-url\"]")
    @step2 = @form.find("[data-step=\"user\"]")
    @step3 = @form.find("[data-step=\"store-details\"], [data-step=\"user-details\"]")
    @step4 = @form.find("[data-step=\"actions\"]")
    @submit = @form.find("button[type=\"submit\"]")
    @cancel = @form.find("button.cancel")

    $('#content-header').find('.page-title').text('New Connection')

    $('#content-header').find('.page-actions').remove()

    @toggle_env()
    @toggle_new_or_existing()

    @

  enableValidation: ->
    @$el.find('form#new-connection-wizard').parsley
      listeners:
        onFormSubmit: (isFormValid, e) =>
          e.preventDefault()
          connectOrLogin = $.trim($('button[type=submit]:visible').first().text().toLowerCase())
          if isFormValid
            @[connectOrLogin].apply @


  toggle_new_or_existing: ->
    @step4.find("[data-user]").hide()
    user_check = @step2.find("input[type=\"radio\"]")
    user_check.on "change", (e) =>
      @step3.fadeIn()
      @step4.find("[data-user]").fadeOut()
      @step4.find("[data-user=\"" + $(e.currentTarget).val() + "\"]").fadeIn()
      @step4.find('button').removeAttr("disabled").removeClass "disabled"
    @enableValidation()

  toggle_env: ->
    @envCheck.on 'change', (e) =>
      @disable_env()
      env = $(e.currentTarget).val()
      @step1_5.fadeIn()
      @step1_5.find("[data-env]").fadeOut()
      @step1_5.find("[data-env=\"" + env + "\"]").fadeIn()
      @cancel.removeClass("disabled").removeAttr "disabled"
      if env=='production'
        @form.find("[data-step='invite-code']").fadeIn()
      else
        @form.find("[data-step='invite-code']").fadeOut()

      @step2.fadeIn()

  cancel: (e) ->
    e.preventDefault()
    Backbone.history.navigate '/connections', trigger: true

  disable_env: ->
    @step1.find('input[type="radio"]:not(:checked)').parent().addClass('disabled')
    @step1.find('input[type="radio"]:checked').parent().removeClass('disabled')

  set_url: ->
    env = @form.find("fieldset[data-step=\"environment\"]").find("input[type=\"radio\"]:checked").val()
    if env == 'custom'
      Augury.url = @$el.find('input.url').val()
    else
      Augury.url = Augury.SignUp.urls[env]

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
        if signup.stores.length == 1
          store_id = signup.stores[0].id
          Augury.vent.trigger 'connection:select', signup, store_id
        else
          view = new Augury.Views.Connections.Select(signup: signup)
          $("#integration_main").html view.render().el

      error: (xhr, textStatus, errorThrown) ->
        Augury.Flash.error 'There was a problem logging in. Please check your credentials and try again.'

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
        Augury.Flash.error 'There was a problem connecting. Please check your credentials and try again.'

