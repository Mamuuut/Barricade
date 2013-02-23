
passport  = require 'passport'

module.exports = 
  getLogin: (req, res) ->
    errors = req.flash().error || []
    res.render 'login', { errors: errors }
  
  postLogin: passport.authenticate( 'local', 
      successRedirect: '/',
      failureRedirect: '/login',
      failureFlash: true )
  
  getLogout: (req, res) ->
    req.logout()
    res.redirect '/'