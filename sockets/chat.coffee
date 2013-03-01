
module.exports =
  
  connect: (io) ->
    io.sockets.on 'connection', (socket) =>
      socket.on 'send message', (message) ->
        socket.get 'user', (err, user) ->
          userMessage =  
            message: message,
            username: user.name
          socket.emit 'new message', userMessage
          socket.broadcast.emit 'new message', userMessage
    