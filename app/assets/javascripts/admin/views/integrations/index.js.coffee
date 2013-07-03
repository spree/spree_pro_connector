Augury.Views.Integrations.Index = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/integrations/index"](store_integrations: Augury.store_integrations, global_integrations: Augury.global_integrations)
    @$el.find('.icon_link[title]').powerTip()

    $('#content-header').find('.page-title').text('Integrations')

    $('#content-header').find('.page-actions').remove()
    $('#content-header').find('.table-cell').after JST["admin/templates/integrations/new_button"]

    this
)
