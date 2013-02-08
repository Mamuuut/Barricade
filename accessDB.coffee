###
 accessDB.coffee
###

mongoose = require 'mongoose'
passport = require 'passport'
LocalStrategy = (require 'passport-local').Strategy
User = require './models/user'

### passport configuration ###
passport.use new LocalStrategy (username, password, done) ->
  User.findOne { username: username }, (err, user) ->
    if err
      return done err
    if !user
      newUser = new User
        username: username
        password: password
      newUser.save (err, user) -> 
        console.log 'newUser saved', err, user
      return done null, newUser
    if !user.validPassword password
      return done null, false, { message: 'Incorrect password.' }
    return done null, user

# serialize user on login
passport.serializeUser (user, done) ->
  done null, user.id

# deserialize user on logout
passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    done err, user

module.exports =
  startup: (db) ->
    mongoose.connect db

    mongoose.connection.on 'open', ->
      console.log 'We have connected to mongodb'
      # Remove all users from DB for test purpose only
      ###
        User.remove (err, users) ->
          console.log 'clear users', users
      ###
  closeDB: ->
    mongoose.disconnect