###
 game.coffee
###

mongoose = require('mongoose')
Schema = mongoose.Schema

Game = new Schema
  date: Date,
  players: [String],
  currentplayer: Number,
  cells: [Number]

module.exports = mongoose.model 'Game', Game