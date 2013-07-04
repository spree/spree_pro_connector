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

    $('#content-header').find('.page-title').text(if @model.isNew() then 'New Scheduler' else 'Edit Scheduler')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/schedulers/back_button"]

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
    Augury.Flash.success "The scheduler has been successfully saved."
)
