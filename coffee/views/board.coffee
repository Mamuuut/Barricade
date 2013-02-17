
define [ 'backbone' ], (Backbone) ->
  BoardView = Backbone.View.extend
    el: $("#board_container"),  
    boardSocket: null,
     
    initialize: ->
      @playerid = @options.playerid
      
      @boardSocket = io.connect('/game_list')

    events: 
      "click .back":  "backToGameList",
    
    render: -> {}
    
    play: (game) -> {}
    
    backToGameList: ->
      @trigger 'back'
   
  BoardView