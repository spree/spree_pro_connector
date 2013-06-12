Augury.Routers.Common = Backbone.Router.extend(
  routes:
    "cancel_dialog": "cancel_dialog"

  cancel_dialog: ->
    $.modal.close()
    window.location.href = '#'
)
