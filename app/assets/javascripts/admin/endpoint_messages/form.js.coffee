  $ ->
    return unless $("#endpoint_message_message").length

    $("#admin-response-headers-button").click ->
      $this = $(this)
      toggleText = $this.data("toggle-text")
      $this.data("toggle-text", $this.text())
      $this.text(toggleText)
      $("#admin-response-headers-container").toggle("display")

    $("#endpoint_message_message").change (e) ->
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

    $textarea = $("#endpoint_message_payload")
    # Creates ACE editor for parameters
    createEditor("endpoint_message_parameters_editor", "endpoint_message_parameters")
    # Creates ACE editor for payload
    payloadEditor = createEditor("endpoint_message_payload_editor", "endpoint_message_payload")

