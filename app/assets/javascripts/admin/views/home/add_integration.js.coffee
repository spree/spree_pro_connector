Augury.Views.Home.AddIntegration = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs
    @model = attrs.integration
    @options.parametersByConsumer = @parametersByConsumer()

  render: ->
    dialog = JST["admin/templates/home/modal"]
    $.modal dialog(
      closeHTML: "<i class=\"icon-remove\"></i>"
      minHeight: 500
      minWidth: 860
      persist: true
      onClose: (dialog) ->
        $.modal.close()
        $("#integrations-select").select2 "val", ""
      options: @options
    )

    $("button.cancel").on "click", ->
      $.modal.close()
      Backbone.history.navigate '/', trigger: true
    $("#modal-tabs").tabs().addClass("ui-tabs-vertical ui-helper-clearfix")
    $("#modal-tabs li").removeClass("ui-corner-top").addClass("ui-corner-left")

    $('.integration-toggle').toggles({
      text: {
        on: 'Enabled', 
        off: 'Disabled' 
      },
      on: true,
      width: 90
    })

    $('input.param').bind "keyup paste", ->
      current = $(@)
      console.log current

      duplicates = $("[name='#{current.attr('name')}']")
      if duplicates.length > 1
        duplicates.val(current.val())

    @

  parametersByConsumer: ->
    @ret = {}

    _.map(@model.get("consumers"), (consumer) =>
      @ret[consumer["name"]] = consumer["requires"]["parameters"]
    )
    @ret
)
