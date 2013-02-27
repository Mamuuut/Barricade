Game = require '../models/game'

connect = (io) ->
  io.sockets.on 'connection', (socket) => 
    
    Game.on 'change:status', (game) ->
      if game.isComplete()
        io.sockets.in(socket.gameId).emit 'game winner', game.getWinnerId()
        game.remove (err) -> {}
      
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
  
    