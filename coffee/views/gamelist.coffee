###
  gamelist.coffee
###

define [ 'backbone', 'GameLineView' ], (Backbone, GameLineView) ->
  GameListView = Backbone.View.extend
    el: $("#games"),  
    gameListSocket: null,
     
    initialize: ->
      @games = @options.games
      @playerid = @options.playerid
      @list = @.$ '.list'
      @games.on 'reset', @render, @
      @games.on 'add', @addGame, @
      
      @gameListSocket = io.connect('/game_list')
      @gameListSocket.on 'update game', (gameId) =>
        @games.get(gameId).fetch()
      @gameListSocket.on 'new game', =>
        @games.fetch()

    events: 
      "click #create": "createGame"
    
    render: ->
      @list.empty()
      @games.each (game) =>
        @addGame game
      
    addGame: (game) ->
      console.log 'addGame', game
      line = new GameLineView { model: game, playerid: @playerid }
      line.render()
      line.on 'join', (gameId) =>
        console.log 'join', gameId
        @gameListSocket.emit 'join game', gameId
      @list.append line.$el
            
    createGame: ->
      @games.create {
        players: [@playerid],
        currentplayer: 0,
        cells: [0,0,0,0,0,0,0,0,0] 
        }, { 
        wait: true,
        success: =>
          @gameListSocket.emit 'new game' 
        } 
   
   GameListView