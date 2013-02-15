###
  gameline.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
  GameLineView = Backbone.View.extend
    tagName: 'li',  
    
    template: _.template($('#game-template').html()),
     
    initialize: ->
     
    events: 
      "click .delete": "deleteGame"
    
    render: ->
      @$el.html @template({ title: @model.get 'date' })
            
    deleteGame: ->
      @model.destroy( {
        success: (model, response) =>
          @$el.remove()
      } )
     
  GameLineView