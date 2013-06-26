Backbone.View = Backbone.View.extend(
  displayErrors: (model, xhr, options) ->
    console.log "Errors present"
    errors = $.parseJSON(xhr.responseText).errors.join(", ")
    Augury.Flash.error "Please fix the following errors: " + errors
)
