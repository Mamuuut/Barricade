###
  chat.coffee
###

module.exports =
  
  startup: (io) ->
    io.sockets.on 'connection', (socket) =>
      
      socket.on 'new user', (username) =>
        socket.username = username
        
      socket.on 'send message', (message) ->
        userMessage =  
          message: message,
          username: socket.username
        socket.emit 'new message', userMessage
        socket.broadcast.emit 'new message', userMessage
    