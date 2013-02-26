mongoose = require 'mongoose'
should = require 'should'
Game = require '../../models/game'

describe 'Game model', ->
  
  game = null
  player1 = 'playerid1'
  player2 = 'playerid2'
  player3 = 'playerid3'
  player4 = 'playerid4'
  player5 = 'playerid5'
  
  before (done) ->
    Game.remove (err, games) ->
      game = new Game
      game.save (err, game) ->
        game.addPlayer {id: player1, name: player1}
        done()
      
  after (done) ->
    Game.remove (err, games) ->
      done()
  
  describe 'Default game', ->
    it 'should have a date', ->
      game.should.have.property('date')
      
    it 'should have players array with one player id', ->
      game.should.have.property('playerIds').be.an.instanceOf(Array).with.lengthOf(1)
      
    it 'should have players array with one player name', ->
      game.should.have.property('playerNames').be.an.instanceOf(Array).with.lengthOf(1)
      
    it 'should have default turn', ->
      game.should.have.property('turn')
      game.turn.should.have.property('player').equal(0)
      game.turn.should.have.property('dice')
    
    it 'should have winner -1', ->
      game.should.have.property('winner').equal(-1)
    
    it 'should have default pawns', ->
      game.should.have.property('pawns')
      game.pawns.should.have.property('red').be.an.instanceOf(Array).with.lengthOf(8)
      game.pawns.should.have.property('green').be.an.instanceOf(Array).with.lengthOf(8)
      game.pawns.should.have.property('yellow').be.an.instanceOf(Array).with.lengthOf(8)
      game.pawns.should.have.property('blue').be.an.instanceOf(Array).with.lengthOf(8)
      game.pawns.should.have.property('barricade').be.an.instanceOf(Array).with.lengthOf(11)
   
    it 'should have red default color', ->
      game.getCurrentColor().should.equal('red')
   
    it 'should be waiting for players', ->
      game.isWaitingPlayer().should.be.true
      
    it 'should nbplayers equal 1', ->
      game.should.have.property('nbplayers').equal(1)
      
    it 'should have playerid1', ->
      game.hasPlayer( player1 ).should.be.true
      
  describe 'Start game alone', ->  
    it 'should not be possible', ->
      res = game.start()
      res.should.be.false
      game.isWaitingPlayer().should.be.true
        
  describe 'Join game', ->  
    it 'should have 2 players', ->
      res = game.addPlayer {id: player2, name: player2}
      res.should.equal(player2)
      game.should.have.property('nbplayers').equal(2)

  describe 'Max players', ->
    it 'should have 4 players max', ->
      game.addPlayer {id: player3, name: player3}
      game.addPlayer {id: player4, name: player4}
      game.should.have.property('nbplayers').equal(4)
      res = game.addPlayer {id: player5, name: player5}
      res.should.be.false
      game.should.have.property('nbplayers').equal(4)
      game.hasPlayer( player5 ).should.be.false

  describe 'Next player', ->
    it 'should loop', ->
      game.nextPlayer()
      game.turn.player.should.equal(1)
      game.nextPlayer()
      game.turn.player.should.equal(2)
      game.nextPlayer()
      game.turn.player.should.equal(3)
      game.nextPlayer()
      game.turn.player.should.equal(0)

  describe 'Remove player', ->
    it 'should remove player playerid2', ->
      res = game.removePlayer player2
      res.should.equal(player2)
      game.should.have.property('nbplayers').equal(3)
      game.hasPlayer(player2).should.be.false
    
    it 'should not remove player playerid2', ->
      res = game.removePlayer player2
      res.should.be.false
      
  describe 'Start game not being master', ->  
    it 'should not be possible', ->
      res = game.start player3 
      res.should.be.false
      game.isPlaying().should.be.false
      
  describe 'Start game being master', ->  
    it 'should be possible', ->
      res = game.start player1 
      res.should.be.true
      game.isPlaying().should.be.true
      
  describe 'Start already started game', ->  
    it 'should not be possible', ->
      res = game.start player1 
      res.should.be.false
      
  describe 'Add player when already playing', ->  
    it 'should not be possible', ->
      res = game.addPlayer player2
      res.should.be.false
      
  describe 'Move pawn', ->
    color = undefined
    src   = '1:14'
    dest  = '0:13'
    it 'src should be player pawn', ->
      color = game.getCurrentColor()
      game.hasPawn(color, src).should.be.true
    
    it 'dest should not be player pawn', ->
      game.hasPawn(color, dest).should.be.false
    
    it 'move should return true', ->
      game.handleMove(src, dest).should.be.true
    
    it 'dest should have a pawn with color', ->
      game.getPawnColor(dest).should.equal(color)
    
    it 'src house should be empty', ->
      game.getEmptyHouse(color).should.equal(src)
      
  describe 'Move pawn not from current player', ->
    src   = '2:14'
    dest  = '1:13'
    it 'move should return false', ->
      game.handleMove(src, dest).should.be.false
      
  describe 'Last player', ->
    it 'should complete the game', ->
      game.removePlayer player3
      game.removePlayer player4
      game.should.have.property('nbplayers').equal(1)
      game.isComplete().should.be.true
      game.should.have.property('winner').equal(0)
      
