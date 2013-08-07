window.Augury.Flash =
  notice: (msg) ->
    @notification 'notice', 5000, msg

  alert: (msg) ->
    @notification 'alert', false, msg

  error: (msg) ->
    @notification 'error', 5000, msg

  success: (msg) ->
    @notification 'success', 5000, msg

  notification: (type, timeout, msg) ->
    $.noty.closeAll()
    noty
      text: msg
      type: type
      theme: 'defaultTheme'
      layout: "top"
      animation:
        open: height: "toggle"
        close: height: "toggle"
        easing: 'swing'
        speed: 500
      timeout: timeout
      closeWith: ['click', 'button']
      modal: false
