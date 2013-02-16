###
 routes.coffee
###

passport = require 'passport'
Game = require './models/game'
        
# Remove all users from DB for test purpose only
Game.remove (err, games) ->
  console.log 'clear games', games

module.exports = (app) ->
  
  ensureAuthenticated = (req, res, next) ->
    if req.isAuthenticated()
      return next() 
    res.redirect '/login'
    
  sendJsonGames = (res) ->
    Game.find (err, games) ->
      res.json games    

  ###
    Index
  ###
  app.get '/', ensureAuthenticated, (req, res) ->
    res.render 'game_list', 
      title: 'Welcome ' + req.user.username
  
  ###
    Games
  ###
  app.get '/games', ensureAuthenticated, (req, res) ->
    sendJsonGames res
      
  app.post '/games', ensureAuthenticated, (req, res) ->
    newGame = new Game req.body
    newGame.save (err, game) -> 
      if err
        res.json {err: err}
      else
        res.json game
      
  app.get '/games/:id', ensureAuthenticated, (req, res) ->
    Game.findById req.params.id, (err, game) ->
      if err
        res.json {err: err}
      else
        res.json game    
    
  app.delete '/games/:id', ensureAuthenticated, (req, res) ->
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
    
  ###
    User
  ###      
  app.get '/user', ensureAuthenticated, (req, res) ->
    res.json 
      name: req.user.username, 
      id: req.user.id
    
  ###
    Login
  ###   
  app.get '/login', (req, res) ->
    errors = req.flash().error || []
    res.render 'login', { errors: errors }
  
  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'
  
  app.post '/login',
    passport.authenticate 'local', 
      {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash: true
      }