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
      params = 
        status: @model.get('status'),
        players: @model.getPlayersStr(), 
        date: @model.getDateStr() 
      @$el.html @template(params)
      @$el.addClass @model.getStatusStr()
            
    deleteGame: ->
      @model.destroy( {
        success: (model, response) =>
          @$el.remove()
      } )
     
  GameLineView