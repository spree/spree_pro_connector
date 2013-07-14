  $ ->
    return unless $("#endpoint_sample_message").length

    $("#admin-response-headers-button").click ->
      $this = $(this)
      toggleText = $this.data("toggle-text")
      $this.data("toggle-text", $this.text())
      $this.text(toggleText)
      $("#admin-response-headers-container").toggle("display")

    $("#endpoint_message_available_endpoints").change (e) ->
      $service = $("#endpoint_message_available_services")
      $service.find("option").remove()
      $(".new_parameter_pairs").remove()
      $("#endpoint_message_uri").val ""
      $service.select2(val: "")
      $service.append("<option value='' selected='selected'></option>")

      $endpoint = $(this).find("option:selected")
      return if $endpoint.val() == ""

      _.each JSON.parse($endpoint.val()), (consumer) ->
        $service.append("<option value='#{JSON.stringify(consumer)}'>#{consumer.name}</option>")

    $("#endpoint_message_available_services").change (e) ->
      $(".new_parameter_pairs").remove()

      $service = $(this).find("option:selected")
      return if $service.val() == ""

      payload = JSON.parse($service.val())

      $endpoint = $("#endpoint_message_available_endpoints").find("option:selected")

      $("#endpoint_message_uri").val "#{$endpoint.data("url")}#{payload.path}"

      return unless payload?.requires?.parameters?

      for parameter in payload.requires.parameters
        addParameterField parameter.name, getParameterValueByName(parameter.name)


    $("#endpoint_sample_message").change (e) ->
      message = messageSearch($(e.target).val())
      if(message)
        # JSON.stringify(value [, replacer] [, space])
        payload = JSON.stringify(message.payload, null, 2)
        $textarea.val(payload)
        payloadEditor.setValue(payload)

    messageSearch = (->
      messages = JSON.parse($("#messages").text())
      return (message) ->
        for sample in messages
          if(sample.table.message == message)
            return sample.table
    )()

    createEditor = (targetId, parentId) ->
      editor = ace.edit(targetId)
      editor.setTheme("ace/theme/chrome")
      editor.getSession().setMode("ace/mode/javascript")
      editor.setShowPrintMargin(false)

      $textarea = $("##{parentId}")
      editor.getSession().setValue($textarea.val())
      editor.getSession().on "change", ->
        $textarea.val(editor.getSession().getValue())
      editor

    if Augury.Preload && Augury.Preload.parameters
      availableTags = _.map Augury.Preload.parameters, (parameter) ->
        { label: parameter.name, value: parameter.name, extra: parameter.value }

    bindParametersAutoCompleteTo = (target) ->
      return unless availableTags
      target.autocomplete source: availableTags, minLength: 0, select: (event, ui) ->
        $(this).closest("div").next("div").children("input.new-parameter-value").val ui.item.extra

    $textarea = $("#endpoint_message_payload")
    # Creates ACE editor for payload
    payloadEditor = createEditor("endpoint_message_payload_editor", "endpoint_message_payload")

    addParameterField = (->
      parameterFieldsIndex = $("#new-parameters .new_parameter_pairs").length

      return (name = "", value="") ->
        parameterFieldsIndex++
        $("#new-parameters").append generateHTMLForParameters(name, value, parameterFieldsIndex)
        bindParametersAutoCompleteTo $("input.new-parameter-name:last")
    )()

    getParameterValueByName = (name) ->
      return "" unless availableTags
      for tag in availableTags
        return tag.extra if tag.label == name

    $(".add-new-parameter").click (e) ->
      e.preventDefault()
      addParameterField()

    $(document).on "click", ".destroy_new_parameter_pairs", (e) ->
      e.preventDefault()
      $(this).closest(".new_parameter_pairs").remove()

    # Generates html for new parameters
    # Copied from backend/app/assets/javascripts/admin/image_settings.js.erb
    generateHTMLForParameters = (name, value, index) ->
      "<div class='new_parameter_pairs row'>
        <div class='field'>
          <div class='five columns'>
            <label for='new_parameter_pairs_#{index}_name'>#{Spree.translations.name}</label>
            <input class='fullwidth new-parameter-name' id='new_parameter_pairs_#{index}_name'
              name='new_parameter_pairs[#{index}][name]' type='text' value='#{name}'><br>
          </div>

          <div class='five columns'>
            <label for='new_parameter_pairs_#{index}_value'>#{Spree.translations.value}</label>
            <input class='fullwidth new-parameter-value' id='new_parameter_pairs_#{index}_value'
              name='new_parameter_pairs[#{index}][value]' type='text' value='#{value}'>
          </div>

          <div class='two columns'>
            <a class='destroy_new_parameter_pairs with-tip button' href='#'
              style='margin-top: 19px;' title='#{Spree.translations.destroy}'>
                <em class='icon-trash'></em> &nbsp; #{Spree.translations.destroy}
            </a>
          </div>
        </div>"

    bindParametersAutoCompleteTo $("input.new-parameter-name")

