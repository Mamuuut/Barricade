###
 user.coffee
###

mongoose  = require 'mongoose'
bcrypt    = require 'bcrypt-nodejs'
Schema    = mongoose.Schema

User = new Schema
  username:   String,
  hash:       String,
  victories:  { type: Number, default: 0 }

User.virtual('password').get ->
  this._password
  
User.virtual('password').set (password) ->
  this._password = password
  this.hash = bcrypt.hashSync password

User.methods.validPassword = (password, callback) ->
  bcrypt.compare password, this.hash, callback

module.exports = mongoose.model 'User', User