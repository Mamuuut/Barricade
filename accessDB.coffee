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
        return done null, newUser
    else
      user.validPassword password, (err, res) ->
        if res
          return done null, user
        else
          return done null, false, { message: 'Incorrect password.' }

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
  closeDB: ->
    mongoose.disconnect