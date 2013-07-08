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
    # Creates ACE editor for payload
    payloadEditor = createEditor("endpoint_message_payload_editor", "endpoint_message_payload")

    $(".add-new-parameter").click (e) ->
      e.preventDefault()
      $("#new-parameters").append(generateHTMLForParameters("new_parameter_pairs"))

    $(document).on "click", ".destroy_new_parameter_pairs", (e) ->
      e.preventDefault()
      $(this).closest(".new_parameter_pairs").remove()

    # Generates html for new parameters
    generateHTMLForParameters = (hash_name) ->
      index = $(".#{hash_name}").length + 1
      html = '<div class="' + hash_name + ' row"><div class="field">'
      html += '<div class="five columns">'
      html += '<label for="' + hash_name + '_' + index + '_name">'
      html += Spree.translations.name + '</label>'
      html += '<input id="' + hash_name + '_' + index + '_name" name="' + hash_name + '[' + index + '][name]" type="text" class="fullwidth"><br>'
      html += '</div><div class="five columns">'
      html += '<label for="' + hash_name + '_' + index + '_value">'
      html += Spree.translations.value + '</label>'
      html += '<input id="' + hash_name + '_' + index + '_value" name="' + hash_name + '[' + index + '][value]" type="text" class="fullwidth">'
      html += '</div><div class="two columns">'
      html += '<a href="#" title="' + Spree.translations.destroy + '" class="destroy_' + hash_name + ' with-tip button" style="margin-top: 19px;"><i class="icon-trash"></i> &nbsp; ' + Spree.translations.destroy + '</a>'
      html += '</div></div></div>'

