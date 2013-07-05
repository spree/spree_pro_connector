describe 'Registration Router', ->
  beforeEach ->
    @registration1 = new Augury.Models.Registration name: "Foobar", url: "http://google.com", token: "123456", keys: ["order:confirmed"]
    @registration2 = new Backbone.Model name: "Something", url: "http://google.com", token: "123456", keys: ["order:confirmed"], integration_id: "1"
    @collection = new Augury.Collections.Registrations [@registration1, @registration2]
    @parameters = new Augury.Collections.Parameters [new Backbone.Model name: "Example", value: "Parameter"]
    Augury.registrations = @collection
    Augury.keys = ["order:confirmed", "order:cancelled"]

    @router = new Augury.Routers.Registrations(collection: @collection, parameters: @parameters)

  describe 'Index action', ->
    describe 'with no integration id', ->
      beforeEach ->
        @indexViewSpy = sinon.spy(Augury.Views.Registrations.Index.prototype, 'render')
        @router.index()
      afterEach ->
        Augury.Views.Registrations.Index.prototype.render.restore()

      it 'renders the index view', ->
        expect(@indexViewSpy).toHaveBeenCalledOnce()

    describe 'with an integration id', ->
      beforeEach ->
        @collectionSpy = sinon.spy(@collection, 'byIntegration')
        @router.index("1")
      afterEach ->
        @collection.byIntegration.restore()

      it 'filters the collection by integration', ->
        expect(@collectionSpy).toHaveBeenCalledOnce()
        expect(@collectionSpy).toHaveBeenCalledWith("1")

  describe 'New action', ->
    beforeEach ->
      @collectionSpy = sinon.spy(Augury.registrations, 'add')
      @editViewSpy = sinon.stub(Augury.Views.Registrations.Edit.prototype, 'render', -> true)
      @router.new()
    afterEach ->
      Augury.Views.Registrations.Edit.prototype.render.restore()
      Augury.registrations.add.restore()

    it 'renders the edit view', ->
      expect(@editViewSpy).toHaveBeenCalledOnce()

    it 'adds a new registration to the global registration collection', ->
      expect(@collectionSpy).toHaveBeenCalledOnce()

  describe 'Edit action', ->
    beforeEach ->
      @collectionSpy = sinon.spy(@collection, 'get')
      @editViewSpy = sinon.stub(Augury.Views.Registrations.Edit.prototype, 'render', -> true)
      @router.edit(@registration1.id)
    afterEach ->
      Augury.Views.Registrations.Edit.prototype.render.restore()
      @collection.get.restore()

    it 'renders the edit view', ->
      expect(@editViewSpy).toHaveBeenCalledOnce()

    it 'finds the registration by id', ->
      expect(@collectionSpy).toHaveBeenCalledOnce()
      expect(@collectionSpy).toHaveBeenCalledWith(@registration1.id)

  describe 'Delete action', ->
    beforeEach ->
      @modalSpy = sinon.spy($, 'modal')
    afterEach ->
      $.modal.close()
      $.modal.restore()

    describe 'when confirm is false', ->
      it 'displays a modal', ->
        @router.delete(@registration1.id, 'false')
        expect(@modalSpy).toHaveBeenCalledOnce()

    describe 'when confirm is true', ->
      beforeEach ->
        @registrationSpy = sinon.spy @registration1, 'destroy'
        # sinon.stub(@collection, 'get', -> @registration1)
        @router.delete(@registration1.id, 'true')

      # it 'destroys the registration', ->
      #   expect(@registrationSpy).toHaveBeenCalledOnce()
