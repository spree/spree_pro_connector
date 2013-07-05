(function() {
  describe('Registration Router', function() {
    beforeEach(function() {
      this.registration1 = new Augury.Models.Registration({
        name: "Foobar",
        url: "http://google.com",
        token: "123456",
        keys: ["order:confirmed"]
      });
      this.registration2 = new Backbone.Model({
        name: "Something",
        url: "http://google.com",
        token: "123456",
        keys: ["order:confirmed"],
        integration_id: "1"
      });
      this.collection = new Augury.Collections.Registrations([this.registration1, this.registration2]);
      this.parameters = new Augury.Collections.Parameters([
        new Backbone.Model({
          name: "Example",
          value: "Parameter"
        })
      ]);
      Augury.registrations = this.collection;
      Augury.keys = ["order:confirmed", "order:cancelled"];
      return this.router = new Augury.Routers.Registrations({
        collection: this.collection,
        parameters: this.parameters
      });
    });
    describe('Index action', function() {
      describe('with no integration id', function() {
        beforeEach(function() {
          this.indexViewSpy = sinon.spy(Augury.Views.Registrations.Index.prototype, 'render');
          return this.router.index();
        });
        afterEach(function() {
          return Augury.Views.Registrations.Index.prototype.render.restore();
        });
        return it('renders the index view', function() {
          return expect(this.indexViewSpy).toHaveBeenCalledOnce();
        });
      });
      return describe('with an integration id', function() {
        beforeEach(function() {
          this.collectionSpy = sinon.spy(this.collection, 'byIntegration');
          return this.router.index("1");
        });
        afterEach(function() {
          return this.collection.byIntegration.restore();
        });
        return it('filters the collection by integration', function() {
          expect(this.collectionSpy).toHaveBeenCalledOnce();
          return expect(this.collectionSpy).toHaveBeenCalledWith("1");
        });
      });
    });
    describe('New action', function() {
      beforeEach(function() {
        this.collectionSpy = sinon.spy(Augury.registrations, 'add');
        this.editViewSpy = sinon.stub(Augury.Views.Registrations.Edit.prototype, 'render', function() {
          return true;
        });
        return this.router["new"]();
      });
      afterEach(function() {
        Augury.Views.Registrations.Edit.prototype.render.restore();
        return Augury.registrations.add.restore();
      });
      it('renders the edit view', function() {
        return expect(this.editViewSpy).toHaveBeenCalledOnce();
      });
      return it('adds a new registration to the global registration collection', function() {
        return expect(this.collectionSpy).toHaveBeenCalledOnce();
      });
    });
    describe('Edit action', function() {
      beforeEach(function() {
        this.collectionSpy = sinon.spy(this.collection, 'get');
        this.editViewSpy = sinon.stub(Augury.Views.Registrations.Edit.prototype, 'render', function() {
          return true;
        });
        return this.router.edit(this.registration1.id);
      });
      afterEach(function() {
        Augury.Views.Registrations.Edit.prototype.render.restore();
        return this.collection.get.restore();
      });
      it('renders the edit view', function() {
        return expect(this.editViewSpy).toHaveBeenCalledOnce();
      });
      return it('finds the registration by id', function() {
        expect(this.collectionSpy).toHaveBeenCalledOnce();
        return expect(this.collectionSpy).toHaveBeenCalledWith(this.registration1.id);
      });
    });
    return describe('Delete action', function() {
      beforeEach(function() {
        return this.modalSpy = sinon.spy($, 'modal');
      });
      afterEach(function() {
        $.modal.close();
        return $.modal.restore();
      });
      describe('when confirm is false', function() {
        return it('displays a modal', function() {
          this.router["delete"](this.registration1.id, 'false');
          return expect(this.modalSpy).toHaveBeenCalledOnce();
        });
      });
      return describe('when confirm is true', function() {
        return beforeEach(function() {
          this.registrationSpy = sinon.spy(this.registration1, 'destroy');
          return this.router["delete"](this.registration1.id, 'true');
        });
      });
    });
  });

}).call(this);
