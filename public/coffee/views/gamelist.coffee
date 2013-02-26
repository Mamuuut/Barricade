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
      @games.on 'remove', @removeGame, @
      
      @socket.on 'update game', (gameId) =>
        @games.get(gameId).fetch()
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
      
    removeGame: (game) ->
      console.log 'removeGame', game
      @socket.emit 'remove game', game.Id
          
    createGame: ->
      @games.create {
        playerIds: [@player.id],
        playerNames: [@player.name],
        currentplayer: 0,
        cells: [0,0,0,0,0,0,0,0,0] 
        }, { 
        wait: true,
        success: =>
          @socket.emit 'new game' 
        } 
   
   GameListView