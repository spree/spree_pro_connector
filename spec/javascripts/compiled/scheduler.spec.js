(function() {
  describe('Scheduler Model', function() {
    beforeEach(function() {
      return this.scheduler = new Augury.Models.Scheduler({
        count: '10',
        interval: 'days'
      });
    });
    return it('should exhibit attributes', function() {
      expect(this.scheduler.get('count')).toEqual('10');
      return expect(this.scheduler.get('interval')).toEqual('days');
    });
  });

}).call(this);
