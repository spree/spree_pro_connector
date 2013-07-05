(function() {
  describe("Registrations Index View", function() {
    beforeEach(function() {
      $('body').append('<div id="integration-main"></div>');
      this.registration = new Backbone.Model({
        name: "Foobar",
        url: "http://google.com",
        keys: ["order:completed"]
      });
      this.collection = new Backbone.Collection([this.registration]);
      this.view = new Augury.Views.Registrations.Index({
        collection: this.collection
      });
      this.viewRenderSpy = sinon.spy(this.view, "render");
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
    return it("has the correct parameter content", function() {
      expect($('tbody td:first')).toHaveText("Foobar");
      expect($('tbody td:nth-child(2)')).toHaveText("http://google.com");
      return expect($('tbody td:nth-child(3)')).toHaveText("order:completed");
    });
  });

}).call(this);
