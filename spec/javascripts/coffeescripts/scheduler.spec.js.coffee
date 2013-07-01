describe 'Scheduler Model', ->
  beforeEach ->
    @scheduler = new Augury.Models.Scheduler
      count: '10'
      interval: 'days'
  it 'should exhibit attributes', ->
    expect(@scheduler.get('count')).toEqual('10')
    expect(@scheduler.get('interval')).toEqual('days')
