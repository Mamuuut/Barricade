Game = require '../models/game'

module.exports =
  
  connect: (io) ->
  
    io.sockets.on 'connection', (socket) =>    
      
      Game.on 'change', (game) ->
        socket.emit 'update game', game.id
        socket.broadcast.emit 'update game', game.id
      
      Game.on 'add', (game) ->
        socket.broadcast.emit 'update list'

      Game.on 'remove', (game) ->
        socket.broadcast.emit 'update list'
            
      socket.on 'join game', (gameId) ->
        Game.findById gameId, (err, game) ->
          if game
            socket.get 'user', (err, user) ->
              if game.addPlayer user
                game.save()
          
      socket.on 'start game', (gameId) ->
        Game.findById gameId, (err, game) ->
          if game
            socket.get 'user', (err, user) ->
              if game.start user.id
                game.save()
          
      socket.on 'quit game', (gameId) ->
        Game.findById gameId, (err, game) ->
          if game
            socket.get 'user', (err, user) ->
              if game.removePlayer user.id
                game.save()
    