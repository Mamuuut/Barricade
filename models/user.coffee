###
 user.coffee
###

mongoose = require('mongoose')
Schema = mongoose.Schema

User = new Schema
  username: String,
  password: String

User.methods.validPassword = ( pwd ) ->
  return this.password is pwd

module.exports = mongoose.model 'User', User