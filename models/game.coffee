###
 game.coffee
###

mongoose  = require 'mongoose'
Schema    = mongoose.Schema
Barricade = require '../public/coffee/barricade'

randomDice = ->
  return Math.ceil (6 * Math.random())

Game = new Schema
  date: { type: Date, default: Date.now }
  players: [String]
  turn: { 
    player: {type: Number, default: 0}
    dice: {type: Number, default: ->
      randomDice()}
  }
  status: { type: Number, default: 0 }
  winner: { type: String, default: "" } 
  pawns: {
    red:        { type: [String], default: Barricade.houses.red.slice(0) }
    green:      { type: [String], default: Barricade.houses.green.slice(0) }
    yellow:     { type: [String], default: Barricade.houses.yellow.slice(0) }
    blue:       { type: [String], default: Barricade.houses.blue.slice(0) }
    barricade:  { type: [String], default: Barricade.barricades.slice(0) }
  }

###
  Status
###
Game.methods.isWaitingPlayer = ->
  'waiting_player' is Barricade.status[@status]

Game.methods.isPlaying = ->
  'playing' is Barricade.status[@status]

Game.methods.isComplete = ->
  'complete' is Barricade.status[@status]

Game.methods.start = (playerId) ->
  if (Barricade.minPlayers <= @nbplayers) and (@isMaster playerId) and @isWaitingPlayer()
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

Game.methods.isCurrentPlayer = (playerId) ->
  return @turn.player is @players.indexOf playerId

Game.methods.hasPlayer = (playerId) ->
  return -1 isnt @players.indexOf playerId

Game.methods.addPlayer = (playerId) ->
  if !@hasPlayer(playerId) and @nbplayers < Barricade.maxPlayers and @isWaitingPlayer()
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

###
  Pawns
###
Game.methods.getCurrentColor = ->
  Barricade.colors[@turn.player]

Game.methods.hasPawn = (color, pawn) ->
  if @pawns[color]
    -1 isnt @pawns[color].indexOf pawn 

Game.methods.movePawn = (src, dest) ->
  color = @getCurrentColor()
  pawnIdx = @pawns[color].indexOf src
  if -1 isnt pawnIdx
    @pawns[color].splice pawnIdx, 1, dest
    @nextPlayer()
    return true
  false

module.exports = mongoose.model 'Game', Game