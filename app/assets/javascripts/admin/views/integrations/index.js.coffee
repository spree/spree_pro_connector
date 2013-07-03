Augury.Views.Integrations.Index = Backbone.View.extend(
  render: ->
    @$el.html JST["admin/templates/integrations/index"](store_integrations: Augury.store_integrations, global_integrations: Augury.global_integrations)
    @$el.find('.icon_link[title]').powerTip()

    # @$el.find('#integrations-list').mixitup()

    this
)
