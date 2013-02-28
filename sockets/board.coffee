Game = require '../models/game'
User = require '../models/user'

connect = (io) ->
  io.sockets.on 'connection', (socket) => 
    
    Game.on 'change:status', (game) ->
      if game.isComplete()
        winnerId = game.getWinnerId()
        if winnerId
          game.winner = -1
          game.remove (err) -> 
            User.findById winnerId, (err, user) ->
              io.sockets.in(socket.gameId).emit 'game winner', winnerId
              user.victories++
              user.save ->
                io.sockets.emit 'update victories'
            
    Game.on 'change:pawns', (game) ->
      io.sockets.in(socket.gameId).emit 'update board'
      
    Game.on 'change:turn', (game) ->
      io.sockets.in(socket.gameId).emit 'update board'

    socket.on 'play', (gameId) ->
      socket.gameId = gameId
      socket.join gameId

    socket.on 'move', (move) ->
      socket.get 'user', (err, user) ->
        Game.findById socket.gameId, (err, game) ->
          if game.isCurrentPlayer user.id
            moveArray = move.split ';'
            src = moveArray[0]
            dest = moveArray[1]
            barricade = moveArray[2]
            if game.handleMove src, dest, barricade
              game.save()
              
    socket.on 'stop', ->
      socket.leave socket.gameId

module.exports = 
  connect: connect
  
    