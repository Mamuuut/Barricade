mongoose = require 'mongoose'
request = require 'supertest' 
should = require 'should'
app = require '../app'
User = require '../models/user'
Game = require '../models/game'

describe 'routes', ->
  
  user = null
  username = 'John'
  realPassword = '1234'
 
  before (done) ->
    User.remove (err, users) ->
      user = new User
        username: username,
        password: realPassword
  
      user.save (err, user) -> 
        done()
      
  after ->
    User.remove
    Game.remove
  
  describe 'GET /login', ->
    it 'respond with html', (done) ->
      request( app )
        .get( '/login' )
        .expect( 'Content-Type', 'text/html; charset=utf-8' )
        .expect( 200, done )
  
  describe 'POST /login failed', ->
    it 'redirect to /login', (done) ->
      request( app )
        .post( '/login' )
        .send( { username: username, password: '1' })
        .expect( 302 )
        .end (err, res) ->
          res.header['location'].should.include('/login')
          done()
          
  describe 'POST /login success', ->
    it 'redirect to /', (done) ->
      request( app )
        .post( '/login' )
        .send( { username: username, password: realPassword })
        .expect( 302 )
        .end (err, res) ->
          res.header['location'].should.not.include('/login')
          cookie = res.headers['set-cookie']
          done()
          
  ###
    Authentication
  ###
  describe 'Authentication', ->
    
    cookie = null

    beforeEach (done) ->
      request( app )
        .post( '/login' )
        .send( { username: username, password: realPassword } )
        .end (err, res) ->
          cookie = res.headers['set-cookie']
          done()

    describe 'GET /', ->
      it 'respond with html', (done) ->
        request( app )
          .get( '/' )
          .set('cookie', cookie)
          .expect( 'Content-Type', 'text/html; charset=utf-8' )
          .expect( 200 )
          .end (err, res) ->
            done()
          
    describe 'GET /user', ->
      it 'respond with json', (done) ->
        request( app )
          .get( '/user' )
          .set('cookie', cookie)
          .end (err, res) ->
            res.body.should.have.property('username').equal(username)
            res.body.should.have.property('userid').equal(user.id)
            done()
    
    ###
      Games
    ###
    describe 'Games', ->
       
      newGame = null
      
      before (done) ->
        newGame = 
          players: [user.id],
          currentplayer: 0,
          cells: [0,0,0,0,0,0,0,0,0]
          
        Game.remove (err, games) ->
          done()
            
      describe 'GET /games', ->
        it 'respond with json', (done) ->
          request( app )
            .get( '/games' )
            .set('cookie', cookie)
            .end (err, res) ->
              res.body.should.be.an.instanceOf(Array)
              res.body.length.should.equal(0)
              done()
            
      describe 'POST /games', ->
        it 'respond with json', (done) ->
          request( app )
            .post( '/games' )
            .set('cookie', cookie)
            .send( newGame )
            .end (err, res) ->
              res.body.should.be.an.instanceOf(Array)
              res.body.length.should.equal(1)
              done()
      