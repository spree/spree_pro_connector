_.extend(Backbone.Validation.callbacks,
  valid: (view, attr, selector) ->
    element = view.$('[' + selector + '~="' + attr + '"]')
    element.removeClass("invalid")
    if element.prev('div.error').length > 0
      element.prev('div.error').html('')
    else
      element.prevUntil('.field', 'div.error').html('')
    view.$('fieldset .error-message').html('')
    return true

  invalid: (view, attr, error, selector) ->
    element = view.$('[' + selector + '~="' + attr + '"]')
    if element.prev('div.error').length > 0
      element.prev('div.error').html(error)
    else
      element.prevUntil('.field', 'div.error').html(error)
    view.$('fieldset .error-message').html('Please fix all validation errors on the form')
    return false
)

Backbone.View = Backbone.View.extend(
  validate: (evt) ->
    field = $(evt.currentTarget)
    name = field.attr("name")
    value = field.val()
    error = @model.preValidate(name, value)

    if error
      field.addClass('invalid')
      field.prev('div.error').html(error)
    else
      field.removeClass('invalid')
      field.prev('div.error').html('')
)
