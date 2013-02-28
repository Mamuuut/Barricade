Game = require '../models/game'
    
sendJsonGames = (res) ->
  Game.find (err, games) ->
    res.json games    

module.exports = 
  getGames: (req, res, next) ->
    sendJsonGames res
      
  postGames: (req, res, next) ->
    newGame = new Game req.body
    newGame.save (err, game) -> 
      if err
        next new Error('Could not create new game')
      else
        res.json game
      
  getGame: (req, res, next) ->
    Game.findById req.params.id, (err, game) ->
      if err or !game
        next new Error('Game ' + req.params.id + ' not found')
      else
        res.json game    
    
  deleteGame: (req, res, next) ->
    Game.findById req.params.id, (err, game) ->
      if err
        next new Error('Game ' + req.params.id + ' not found')
      else if game
        game.remove (err) -> 
          if err
            next new Error('Could not remove game ' + req.params.id)
          else
            sendJsonGames res
      else
        sendJsonGames res