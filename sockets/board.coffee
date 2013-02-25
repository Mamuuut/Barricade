Game = require '../models/game'

connect = (io) ->
  io.sockets.on 'connection', (socket) =>

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
            if game.movePawn src, dest, barricade
              game.save (err, game) ->   
                io.sockets.in(socket.gameId).emit 'move', 'ok'
            else
              socket.emit 'move', 'Error: move pawn failed'
          else
            socket.emit 'move', 'Error: user is not the current player'
              
    socket.on 'stop', ->
      socket.leave socket.gameId

module.exports = 
  connect: connect
  
    