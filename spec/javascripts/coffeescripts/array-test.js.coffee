Todo = Backbone.Model.extend()

describe "A Model", ->
  describe "when created", ->
    it "should exhibit attributes", ->
      todo = new Todo title: 'Rake Leaves'
      expect(todo.get('title')).toEqual('Rake Leaves')
