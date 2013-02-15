###
 game.coffee
###

mongoose = require('mongoose')
Schema = mongoose.Schema

MIN_PLAYERS = 2
MAX_PLAYERS = 4
STATUS = ['waiting_player', 'playing', 'complete']

Game = new Schema
  date: { type: Date, default: Date.now },
  players: [String],
  currentplayer: { type: Number, default: 0 },
  status: { type: Number, default: 0 }

###
  Status
###
Game.methods.isWaitingPlayer = ->
  'waiting_player' is STATUS[@status]

Game.methods.isPlaying = ->
  'playing' is STATUS[@status]

Game.methods.isComplete = ->
  'complete' is STATUS[@status]

Game.methods.start = ->
  if MIN_PLAYERS <= @nbplayers
    @status = 1
    return true
  return false

###
  Players
###
Game.virtual('nbplayers').get ->
  @players.toObject().length

Game.methods.hasPlayer = (playerId) ->
  return -1 isnt @players.indexOf playerId

Game.methods.addPlayer = (playerId) ->
  if !@hasPlayer(playerId) and @nbplayers < MAX_PLAYERS and !@isPlaying()
    @players.push playerId
    return playerId
  return false

Game.methods.removePlayer = (playerId) ->
  if @hasPlayer playerId
    @players.splice @players.indexOf(playerId), 1
    return playerId
  return false
  
Game.methods.nextPlayer = ->
  @currentplayer = ++@currentplayer % @nbplayers

module.exports = mongoose.model 'Game', Game