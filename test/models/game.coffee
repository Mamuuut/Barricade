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
        players: [player1]
      game.save (err, game) ->
        done()
      
  after (done) ->
    Game.remove (err, games) ->
      done()
  
  describe 'Default game', ->
    it 'should have a date', ->
      game.should.have.property('date')
      
    it 'should have players array with one player', ->
      game.should.have.property('players').be.an.instanceOf(Array).with.lengthOf(1)
      
    it 'should have default turn', ->
      game.should.have.property('turn')
      game.turn.should.have.property('player').equal(0)
      game.turn.should.have.property('dice')
    
    it 'should have winner -1', ->
      game.should.have.property('winner').equal("")
   
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
      res = game.addPlayer player2
      res.should.equal(player2)
      game.should.have.property('nbplayers').equal(2)

  describe 'Max players', ->
    it 'should have 4 players max', ->
      game.addPlayer player3
      game.addPlayer player4
      game.should.have.property('nbplayers').equal(4)
      res = game.addPlayer player5
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
      
  describe 'Last player', ->
    it 'should complete the game', ->
      game.removePlayer player3
      game.removePlayer player4
      game.should.have.property('nbplayers').equal(1)
      game.isComplete().should.be.true
      game.should.have.property('winner').equal(player1)
      
      