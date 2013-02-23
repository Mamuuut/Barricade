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
      @games.on 'remove', @removeGame, @
      
      @gameListSocket = io.connect('/game_list')
      @gameListSocket.on 'update game', (gameId) =>
        @games.get(gameId).fetch()
      @gameListSocket.on 'update list', =>
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
      
      # Socket
      line.on 'join', (gameId) =>
        @gameListSocket.emit 'join game', gameId
      line.on 'start', (gameId) =>
        @gameListSocket.emit 'start game', gameId
      line.on 'quit', (gameId) =>
        @gameListSocket.emit 'quit game', gameId
      line.on 'play', (game) =>
        @trigger 'play', game
      
      @list.append line.$el
      
    removeGame: (game) ->
      console.log 'removeGame', game
      @gameListSocket.emit 'remove game', game.Id
          
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