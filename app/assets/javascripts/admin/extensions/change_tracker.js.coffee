# If you add the follow event to your View this will automatically update
# all attributes on your model when the input field changes.
#
#     'change :input': 'changed'
#
# Note: The name attribute of the field must match the attrbiute name:
Backbone.View = Backbone.View.extend(
  changed: (evt) ->
    field = $(evt.currentTarget)
    name = field.attr("name")
    attrs = {}
    if field.is("input[type=\"checkbox\"]")
      attrs[name] = field.is(":checked")
    else
      attrs[name] = field.val()
    @model.set attrs,
      silent: true

    @model.collection.trigger "change", @model  if _.isObject(@model.collection)
    evt.stopPropagation()
)
