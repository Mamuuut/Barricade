###
  gameline.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
  GameLineView = Backbone.View.extend
    tagName: 'li',  
    
    template: _.template($('#game-template').html()),
     
    initialize: ->
     
    events: 
      "click #create": "createGame"
    
    render: ->
      @$el.html @template({ title: @model.get 'date' })
            
    createGame: ->
      @games.create 
        players: [@playerid],
        currentplayer: 0,
        cells: [0,0,0,0,0,0,0,0,0]
     
  GameLineView