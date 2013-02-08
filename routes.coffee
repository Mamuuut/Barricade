###
 routes.coffee
###

passport = require 'passport'
    
module.exports = (app) ->
  
  ensureAuthenticated = (req, res, next) ->
    if req.isAuthenticated()
      return next() 
    res.redirect '/login'

  app.get '/', ensureAuthenticated, (req, res) ->
    res.render 'index', { title: 'Welcome ' + req.user.username }
  
  app.get '/username', ensureAuthenticated, (req, res) ->
    res.json { username: req.user.username }
    
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