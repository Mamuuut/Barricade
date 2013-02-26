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
  playerIds:    [String]
  playerNames:  [String]
  turn: { 
    player: {type: Number, default: 0}
    dice: {type: Number, default: ->
      randomDice()}
  }
  status: { type: Number, default: 0 }
  winner: { type: Number, default: -1 }
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

Game.methods.completeGame = ->
  if @isPlaying()
    @status = 2
    @winner = @turn.player
    return true
  return false

###
  Players
###
Game.virtual('nbplayers').get ->
  @playerIds.toObject().length

Game.methods.isMaster = (playerId) ->
  return 0 is @playerIds.indexOf playerId

Game.methods.isCurrentPlayer = (playerId) ->
  return @turn.player is @playerIds.indexOf playerId

Game.methods.hasPlayer = (playerId) ->
  return -1 isnt @playerIds.indexOf playerId

Game.methods.addPlayer = (player) ->
  if !@hasPlayer(player.id) and @nbplayers < Barricade.maxPlayers and @isWaitingPlayer()
    @playerIds.push player.id
    @playerNames.push player.name
    return player.id
  return false

Game.methods.removePlayer = (playerId) ->
  if (@hasPlayer playerId) and !@isComplete()
    if playerId is @playerIds[@turn.player]
      @turn.dice = randomDice()
    
    idx = @playerIds.indexOf playerId
    @playerIds.splice idx, 1
    @playerNames.splice idx, 1
    
    @turn.player = @turn.player % @nbplayers
    
    if (@nbplayers is 1) and @isPlaying()
      @completeGame()
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

Game.methods.isCurrentPlayerPawn = (pawn) ->
  color = @getCurrentColor()
  @hasPawn color, pawn

Game.methods.getPawnColor = (pawn) ->
  res = undefined
  (res = if @hasPawn(color, pawn) then color else res) for color in Barricade.colors
  res

Game.methods.isBarricade = (pawn) ->
  @hasPawn 'barricade', pawn

Game.methods.isExit = (pawn) ->
  Barricade.exit is pawn

Game.methods.getEmptyHouse = (color) ->
  res = undefined
  (res = if @hasPawn(color, house) then res else house) for house in Barricade.houses[color]
  res

Game.methods.hasPawn = (color, pawn) ->
  if @pawns[color]
    return -1 isnt @pawns[color].indexOf pawn 

Game.methods.handleMove = (src, dest, barricade) ->
  if @isCurrentPlayerPawn(src) and !@isCurrentPlayerPawn(dest)
    color = @getCurrentColor()
    
    destPawnColor = @getPawnColor dest
    if destPawnColor and color isnt destPawnColor
      house = @getEmptyHouse destPawnColor
      @movePawn destPawnColor, dest, house
    else if barricade and @isBarricade dest 
      @movePawn 'barricade', dest, barricade
   
    @movePawn color, src, dest
    
    if @isExit dest
      @completeGame()
    else
      @nextPlayer()
    return true
  false

Game.methods.movePawn = (color, src, dest) ->
  pawnIdx = @pawns[color].indexOf src
  @pawns[color].splice pawnIdx, 1, dest

Game.plugin require('mongoose-eventify')
module.exports = mongoose.model 'Game', Game