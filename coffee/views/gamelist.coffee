###
  gamelist.coffee
###

define [ 'backbone', 'GameLineView' ], (Backbone, GameLineView) ->
  GameListView = Backbone.View.extend
    el: $("#games"),  
     
    initialize: ->
      @games = @options.games
      @playerid = @options.playerid
      @list = @.$ '.list'
      @games.on 'add', @addGame, @
     
    events: 
      "click #create": "createGame"
    
    render: ->
      @list.empty()
      @games.each (game) =>
        @addGame game
      
    addGame: (game) ->
      line = new GameLineView { model: game, playerid: @playerid }
      line.render()
      @list.append line.$el
            
    createGame: ->
      @games.create {
        players: [@playerid],
        currentplayer: 0,
        cells: [0,0,0,0,0,0,0,0,0] 
        }, { wait: true } 
   
   GameListView