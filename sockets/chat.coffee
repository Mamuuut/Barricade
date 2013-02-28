
module.exports =
  
  connect: (io) ->
    io.sockets.on 'connection', (socket) =>
      console.log 'Chat - connection'
      socket.on 'send message', (message) ->
        console.log 'Chat - send message', message
        socket.get 'user', (err, user) ->
          userMessage =  
            message: message,
            username: user.name
          socket.emit 'new message', userMessage
          socket.broadcast.emit 'new message', userMessage
    