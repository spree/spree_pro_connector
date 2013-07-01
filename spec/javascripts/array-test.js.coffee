describe 'Array', ->

  beforeEach ->
    @array = [1,2,3]

  describe '#indexOf()', ->

    it 'should return -1 when not present', ->
      @array.indexOf(4).should.equal -1
