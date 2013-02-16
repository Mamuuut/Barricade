###
  socket.coffee
###
Game = require './models/game'

module.exports =
  
  startup: (io) ->
    io.sockets.on 'connection', (socket) =>
      
      socket.on 'new user', (user) =>
        socket.set 'user', user
        
      ###
        Chat
      ###
      socket.on 'send message', (message) ->
        socket.get 'user', (err, user) ->
          userMessage =  
            message: message,
            username: user.name
          socket.emit 'new message', userMessage
          socket.broadcast.emit 'new message', userMessage
      
      ###
        Game list
      ###
      socket.on 'new game', (message) ->
        socket.broadcast.emit 'new game'
          
      socket.on 'join game', (gameId) ->
        console.log 'join game', gameId
        Game.findById gameId, (err, game) ->
          if game
            socket.get 'user', (err, user) ->
              if game.addPlayer user.id
                game.save ->   
                  socket.emit 'update game', gameId
                  socket.broadcast.emit 'update game', gameId
    