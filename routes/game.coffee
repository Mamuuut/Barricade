Game = require '../models/game'
    
sendJsonGames = (res) ->
  Game.find (err, games) ->
    res.json games    

module.exports = 
  getGames: (req, res) ->
    sendJsonGames res
      
  postGames: (req, res) ->
    newGame = new Game req.body
    newGame.save (err, game) -> 
      if err
        res.json {err: err}
      else
        res.json game
      
  getGame: (req, res) ->
    Game.findById req.params.id, (err, game) ->
      if err
        res.json {err: err}
      else
        res.json game    
    
  deleteGame: (req, res) ->
    Game.findById req.params.id, (err, game) ->
      if err
        res.json {err: err}
      else if game
        game.remove (err) -> 
          if err
            res.json {err: err}
          else
            sendJsonGames res
      else
        sendJsonGames res