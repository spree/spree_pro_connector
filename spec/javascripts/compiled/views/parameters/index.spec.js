(function() {
  describe("Parameters Index View", function() {
    beforeEach(function() {
      $('body').append('<div id="integration-main"></div>');
      this.view = new Augury.Views.Parameters.Index();
      this.viewRenderSpy = sinon.spy(this.view, "render");
      this.parameter1 = new Backbone.Model({
        name: "Foobar",
        value: "Something"
      });
      Augury.parameters = new Backbone.Collection([this.parameter1]);
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
      return expect($('tbody td:nth-child(2)')).toHaveText("Something");
    });
  });

}).call(this);
