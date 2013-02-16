Game = require './models/game'

module.exports =
  
  startup: (io) ->

    gameList = io
      .of('/game_list')
      .on 'connection', (socket) =>  
      
        socket.on 'new game', (message) ->
          socket.broadcast.emit 'new game'
            
        socket.on 'join game', (gameId) ->
          Game.findById gameId, (err, game) ->
            if game
              socket.get 'user', (err, user) ->
                if game.addPlayer user.id
                  game.save ->   
                    socket.emit 'update game', gameId
                    socket.broadcast.emit 'update game', gameId
            
        socket.on 'start game', (gameId) ->
          Game.findById gameId, (err, game) ->
            if game
              socket.get 'user', (err, user) ->
                if game.start user.id
                  game.save ->   
                    socket.emit 'update game', gameId
                    socket.broadcast.emit 'update game', gameId
    