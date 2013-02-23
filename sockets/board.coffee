
connect = (io) ->
  io.sockets.on 'connection', (socket) =>

    socket.on 'play', (gameId) ->
      socket.gameId = gameId
      socket.join gameId

    socket.on 'move', (move) ->
      io.sockets.in(socket.gameId).emit 'move'
    
    socket.on 'stop', ->
      socket.leave socket.gameId

module.exports = 
  connect: connect
  
    