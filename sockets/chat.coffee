
module.exports =
  
  connect: (io) ->

    chat = io
      .of('/chat')
      .on 'connection', (socket) =>
          
        socket.on 'send message', (message) ->
          socket.get 'user', (err, user) ->
            userMessage =  
              message: message,
              username: user.name
            socket.emit 'new message', userMessage
            socket.broadcast.emit 'new message', userMessage
    