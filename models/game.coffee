###
 game.coffee
###

mongoose = require('mongoose')
Schema = mongoose.Schema

MIN_PLAYERS = 2
MAX_PLAYERS = 4
STATUS = ['waiting_player', 'playing', 'complete']

randomDice = ->
  return Math.ceil (6 * Math.random())

Game = new Schema
  date: { type: Date, default: Date.now },
  players: [String],
  turn: { 
    player: {type: Number, default: 0}
    dice: {type: Number, default: ->
      randomDice()}
  },
  status: { type: Number, default: 0 },
  winner: { type: String, default: "" } 

###
  Status
###
Game.methods.isWaitingPlayer = ->
  'waiting_player' is STATUS[@status]

Game.methods.isPlaying = ->
  'playing' is STATUS[@status]

Game.methods.isComplete = ->
  'complete' is STATUS[@status]

Game.methods.start = (playerId) ->
  if (MIN_PLAYERS <= @nbplayers) and (@isMaster playerId) and @isWaitingPlayer()
    @status = 1
    return true
  return false

Game.methods.completeGame = (playerId) ->
  if @isPlaying()
    @status = 2
    @winner = playerId
    return true
  return false

###
  Players
###
Game.virtual('nbplayers').get ->
  @players.toObject().length

Game.methods.isMaster = (playerId) ->
  return 0 is @players.indexOf playerId

Game.methods.hasPlayer = (playerId) ->
  return -1 isnt @players.indexOf playerId

Game.methods.addPlayer = (playerId) ->
  if !@hasPlayer(playerId) and @nbplayers < MAX_PLAYERS and @isWaitingPlayer()
    @players.push playerId
    return playerId
  return false

Game.methods.removePlayer = (playerId) ->
  if (@hasPlayer playerId) and !@isComplete()
    if playerId is @players[@turn.player]
      @turn.dice = randomDice()
    
    @players.splice @players.indexOf(playerId), 1
    
    @turn.player = @turn.player % @nbplayers
    
    if (@nbplayers is 1) and @isPlaying()
      @completeGame @players[0]
    return playerId
  return false
  
Game.methods.nextPlayer = ->
  @turn.player = ++@turn.player % @nbplayers
  @turn.dice = randomDice()

module.exports = mongoose.model 'Game', Game