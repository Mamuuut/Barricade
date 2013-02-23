###
 routes.coffee
###

index = require './routes/index'
login = require './routes/login'
game  = require './routes/game'
        
# Remove all games from DB for test purpose only
###
Game.remove (err, games) ->
  console.log 'clear games', games
###

module.exports = (app) ->
  
  ensureAuthenticated = (req, res, next) ->
    if req.isAuthenticated()
      return next() 
    res.redirect '/login'
    
  #Login
  app.get     '/login',     login.getLogin
  app.post    '/login',     login.postLogin
  app.get     '/logout',    login.getLogout

  #Index
  app.get     '/',          ensureAuthenticated, index.getIndex
  app.get     '/user',      ensureAuthenticated, index.getUser
  
  #Games
  app.get     '/games',     ensureAuthenticated, game.getGames
  app.post    '/games',     ensureAuthenticated, game.postGames
  app.get     '/games/:id', ensureAuthenticated, game.getGame
  app.delete  '/games/:id', ensureAuthenticated, game.deleteGame
