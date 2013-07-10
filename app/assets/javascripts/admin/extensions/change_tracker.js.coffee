# If you add the follow event to your View this will automatically update
# all attributes on your model when the input field changes.
#
#     'change :input': 'changed'
#
# Note: The name attribute of the field must match the attrbiute name:
Backbone.View = Backbone.View.extend(
  changed: (evt) ->
    field = $(evt.currentTarget)
    name = field.attr("name").replace("-", "_")
    if name.indexOf("[") > -1
      pattern = /((?:[a-z][a-z]+)).*?((?:[a-z][a-z0-9_]*))/i
      matches = name.match(pattern)
      root = matches[1]
      attr = matches[2]
    attrs = {}
    if root && attr
      if field.is("input[type=\"checkbox\"]")
        attrs[root] = {}
        attrs[root][attr] = field.is(":checked")
      else
        attrs[root] = {}
        attrs[root][attr] = field.val()
    else if field.is("input[type=\"checkbox\"]")
      attrs[name] = field.is(":checked")
    else
      attrs[name] = field.val()
    @model.set attrs,
      silent: true

    @model.collection.trigger "change", @model  if _.isObject(@model.collection)
    evt.stopPropagation()
  
)
