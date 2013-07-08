(function() {
  describe("Registrations Index View", function() {
    beforeEach(function() {
      $('body').append('<div id="integration-main"></div>');
      this.registration = new Augury.Models.Registration({
        name: "Foobar",
        url: "http://google.com",
        keys: ["order:completed"]
      });
      this.collection = new Augury.Collections.Registrations([this.registration]);
      this.view = new Augury.Views.Registrations.Index({
        collection: this.collection
      });
      this.viewRenderSpy = sinon.spy(this.view, "render");
      sinon.stub(Augury, 'handle_link_clicks');
      return $('#integration-main').html(this.view.render().el);
    });
    afterEach(function() {
      return $('#integration-main').html('');
    });
    it("renders the view", function() {
      expect(this.viewRenderSpy).toHaveBeenCalled();
      expect($('table.index')).toBeVisible();
      return expect($('a.new')).toBeVisible();
    });
    it("has the correct parameter content", function() {
      expect($('tbody td:first')).toHaveText("Foobar");
      expect($('tbody td:nth-child(2)')).toHaveText("http://google.com");
      return expect($('tbody td:nth-child(3)')).toHaveText("order:completed");
    });
    return describe("clicking the new registration link", function() {
      beforeEach(function() {
        this.routerSpy = sinon.spy(Augury.Routers.Registrations.prototype, 'new');
        return $('a.new').trigger('click');
      });
      return it("shows the new registration form", function() {
        return expect($('fieldset')).toBeVisible();
      });
    });
  });

}).call(this);
