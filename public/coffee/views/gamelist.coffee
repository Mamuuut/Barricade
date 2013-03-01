###
  gamelist.coffee
###

define [ 'backbone', 'GameLineView' ], (Backbone, GameLineView) ->
  GameListView = Backbone.View.extend
    el: $("#games"),  
    socket: null,
     
    initialize: ->
      @socket = @options.socket
      @games  = @options.games
      @player = @options.player
      @list   = @.$ '.list'
      @games.on 'reset', @render, @
      @games.on 'add', @addGame, @
      
      @socket.on 'update game', (gameId) =>
        game = @games.get gameId 
        if game
          game.fetch()
      @socket.on 'update list', =>
        @games.fetch()

    events: 
      "click #create": "createGame"
    
    render: ->
      @list.empty()
      @games.each (game) =>
        @addGame game
      
    addGame: (game) ->
      console.log 'addGame', game
      line = new GameLineView { model: game, playerid: @player.id }
      line.render()
      
      # Socket
      line.on 'join', (gameId) =>
        @socket.emit 'join game', gameId
      line.on 'start', (gameId) =>
        @socket.emit 'start game', gameId
      line.on 'quit', (gameId) =>
        @socket.emit 'quit game', gameId
      line.on 'play', (game) =>
        @trigger 'play', game
      
      @list.append line.$el
          
    createGame: ->
      @games.create {
        playerIds: [@player.id],
        playerNames: [@player.name],
        currentplayer: 0,
        cells: [0,0,0,0,0,0,0,0,0] 
        }, { wait: true } 
   
   GameListView