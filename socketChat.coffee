
module.exports =
  
  startup: (io) ->

    chat = io
      .of('/chat')
      .on 'connection', (socket) =>

        socket.on 'new user', (user) =>
          socket.set 'user', user
          
        socket.on 'send message', (message) ->
          socket.get 'user', (err, user) ->
            userMessage =  
              message: message,
              username: user.name
            socket.emit 'new message', userMessage
            socket.broadcast.emit 'new message', userMessage
    