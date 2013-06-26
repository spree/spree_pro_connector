Augury.Views.Schedulers.Edit = Backbone.View.extend(
  initialize: (attrs) ->
    @options = attrs

  events:
    'click button#save': 'save'
    'click button#cancel': 'cancel'
    'change :input': 'changed'
    'focusout :input': 'validate'

  render: ->
    @$el.html JST["admin/templates/schedulers/edit"](scheduler: @model, keys: @options.keys)
    Backbone.Validation.bind @
    @$('#scheduler-key.select2').select2().select2(
      'val',
      @model.get('key')
    )
    @

  save: (e) ->
    e.preventDefault()
    @model.validate()
    if @model.isValid()
      @model.save {}, success: @saved, error: @displayErrors

  cancel: (e) ->
    e.preventDefault()
    if @model.isNew()
      Augury.schedulers.remove @model
    Backbone.history.navigate '/schedulers', trigger: true

  saved: ->
    console.log "Model updated!"
)
