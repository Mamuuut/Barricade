###
 user.coffee
###

mongoose = require('mongoose')
Schema = mongoose.Schema

User = new Schema
  username:   String,
  password:   String,
  victories:  { type: Number, default: 0 }

User.methods.validPassword = ( pwd ) ->
  return @password is pwd

module.exports = mongoose.model 'User', User