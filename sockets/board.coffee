Game = require '../models/game'

connections = {}
    
connectBoard = (io, id) ->  
  if !connections[id]
    connections[id] = io
      .of('/board/' + id)
      .on 'connection', (socket) ->
        
        socket.on 'move', (move) ->
          socket.get 'user', (err, user) ->
            console.log 'move', move, 'received from', user

connect = (io) ->
  Game.find (err, games) ->
    connectBoard io, game.id for game in games when game.isPlaying()

module.exports = 
  connect: connect
  
    