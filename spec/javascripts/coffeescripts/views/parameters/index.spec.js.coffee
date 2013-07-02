describe "Parameters Index View", ->
  beforeEach ->
    $('body').append('<div id="integration-main"></div>')
    @view = new Augury.Views.Parameters.Index()
    @viewRenderSpy = sinon.spy(@view, "render")
    @parameter1 = new Backbone.Model name: "Foobar", value: "Something"
    Augury.parameters = new Backbone.Collection [@parameter1]
    $('#integration-main').html(@view.render().el)

  afterEach ->
    $('#integration-main').html('')

  it "renders the view", ->
    expect(@viewRenderSpy).toHaveBeenCalled()
    expect($('table.index')).toBeVisible()
    expect($('a.new')).toBeVisible()

  it "has the correct parameter content", ->
    expect($('tbody td:first')).toHaveText("Foobar")
    expect($('tbody td:nth-child(2)')).toHaveText("Something")
