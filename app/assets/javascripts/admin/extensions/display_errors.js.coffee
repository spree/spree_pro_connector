Backbone.View = Backbone.View.extend(
  displayErrors: (model, xhr, options) ->
    errors = $.parseJSON(xhr.responseText).errors.join(", ")
    Augury.Flash.error "Please fix the following errors: " + errors
)
