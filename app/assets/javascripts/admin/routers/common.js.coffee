Augury.Routers.Common = Backbone.Router.extend(
  routes:
    "cancel_dialog": "cancel_dialog"

  cancel_dialog: (e) ->
    $('#confirm_delete').dialog 'close'
    Backbone.history.navigate '/'
)
