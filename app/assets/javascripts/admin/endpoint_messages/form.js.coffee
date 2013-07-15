  $ ->
    return unless $("#endpoint_sample_message").length

    $("#admin-response-headers-button").click ->
      $this = $(this)
      toggleText = $this.data("toggle-text")
      $this.data("toggle-text", $this.text())
      $this.text(toggleText)
      $("#admin-response-headers-container").toggle("display")



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

    $textarea = $("#endpoint_message_payload")
    # Creates ACE editor for payload
    payloadEditor = createEditor("endpoint_message_payload_editor", "endpoint_message_payload")

    Parameters = new class
      constructor: ->
        $(".add-new-parameter").click (e) =>
          e.preventDefault()
          @addParameter()

        $(document).on "click", ".destroy_new_parameter_pairs", (e) ->
          e.preventDefault()
          $(this).closest(".new_parameter_pairs").remove()

        @bindAutoCompleteTo $("input.new-parameter-name")

      bindAutoCompleteTo: (target) ->
        return unless availableTags
        target.autocomplete source: availableTags, minLength: 0, select: (event, ui) ->
          $(this).closest("div").next("div").children("input.new-parameter-value").val ui.item.extra

      addParameter: do =>
        parameterFieldsIndex = $("#new-parameters .new_parameter_pairs").length

        return (name = "", value = "") ->
          parameterFieldsIndex++
          $("#new-parameters").append @generateHTMLFor(name, value, parameterFieldsIndex)
          @bindAutoCompleteTo $("input.new-parameter-name:last")

      # Generates html for new parameters
      # Based on backend/app/assets/javascripts/admin/image_settings.js.erb
      generateHTMLFor: (name, value, index) ->
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

      getParameterValueByName: (name) ->
        return "" unless availableTags
        for tag in availableTags
          return tag.extra if tag.label == name

      removeAll: ->
        $(".new_parameter_pairs").remove()


    Endpoints = new class
      constructor: ->
        $("#endpoint_message_available_endpoints").change (e) =>
          Services.removeAll()
          Parameters.removeAll()
          $("#endpoint_message_uri").val ""

          $endpoint = @selected()

          return if $endpoint.val() == ""

          Services.populate($endpoint.val())

      selected: ->
        $("#endpoint_message_available_endpoints").find("option:selected")

    Services = new class
      constructor: ->
        $("#endpoint_message_available_services").change (e) =>
          Parameters.removeAll()

          $service = @selected()

          return if $service.val() == ""

          payload = JSON.parse($service.val())

          $endpoint = Endpoints.selected()

          $("#endpoint_message_uri").val "#{$endpoint.data("url")}#{payload.path}"

          return unless payload.requires?.parameters?

          for parameter in payload.requires.parameters
            Parameters.addParameter parameter.name, Parameters.getParameterValueByName(parameter.name)

      selected: ->
        $("#endpoint_message_available_services").find("option:selected")

      removeAll: ->
        $service = $("#endpoint_message_available_services")
        $service.find("option").remove()
        $service.select2(val: "")
        $service.append("<option value='' selected='selected'></option>")

      populate: (consumers) ->
        $service = $("#endpoint_message_available_services")

        _.each JSON.parse(consumers), (consumer) ->
          $service.append("<option value='#{JSON.stringify(consumer)}'>#{consumer.name}</option>")

