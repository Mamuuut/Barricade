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

  app.get '/', ensureAuthenticated, (req, res) ->
    res.render 'game_list', 
      title: 'Welcome ' + req.user.username
  
  app.get '/games', ensureAuthenticated, (req, res) ->
    Game.find (err, games) ->
      res.json games
      
  app.post '/games', ensureAuthenticated, (req, res) ->
    newGame = new Game req.body
    newGame.save (err, user) -> 
      console.log 'newGame saved', err, user
  
  app.get '/user', ensureAuthenticated, (req, res) ->
    res.json { username: req.user.username, userid: req.user.id }
    
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