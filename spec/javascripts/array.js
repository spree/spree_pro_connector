describe('Array', function() {
  beforeEach(function() {
    this.array = [1, 2, 3];
  });
  describe('#indexOf()', function() {
    it('should return -1 when not present', function() {
      array.indexOf(4).should.equal(-1);
    });
  });
});
