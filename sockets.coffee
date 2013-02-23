chat      = require './sockets/chat'
board     = require './sockets/board'
gameList  = require './sockets/gameList'

module.exports =
  
  connect: (io) ->
    
    io.sockets.on 'connection', (socket) =>

      socket.on 'new user', (user) =>
        socket.set 'user', user
    
        new chat.connect io
        new board.connect io
        new gameList.connect io    