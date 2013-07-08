describe "Registrations Index View", ->
  beforeEach ->
    $('body').append('<div id="integration-main"></div>')
    @registration = new Augury.Models.Registration
      name: "Foobar"
      url: "http://google.com"
      keys: ["order:completed"]
    @collection = new Augury.Collections.Registrations [@registration]
    @view = new Augury.Views.Registrations.Index(collection: @collection)
    @viewRenderSpy = sinon.spy(@view, "render")
    sinon.stub(Augury, 'handle_link_clicks')
    $('#integration-main').html(@view.render().el)

  afterEach ->
    $('#integration-main').html('')

  it "renders the view", ->
    expect(@viewRenderSpy).toHaveBeenCalled()
    expect($('table.index')).toBeVisible()
    expect($('a.new')).toBeVisible()

  it "has the correct parameter content", ->
    expect($('tbody td:first')).toHaveText("Foobar")
    expect($('tbody td:nth-child(2)')).toHaveText("http://google.com")
    expect($('tbody td:nth-child(3)')).toHaveText("order:completed")

  describe "clicking the new registration link", ->
    beforeEach ->
      @routerSpy = sinon.spy(Augury.Routers.Registrations.prototype, 'new')
      $('a.new').trigger('click')

    it "shows the new registration form", ->
      expect($('fieldset')).toBeVisible()
