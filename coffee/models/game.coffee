###
  game_model.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
  MIN_PLAYERS = 2
  MAX_PLAYERS = 4
  STATUS = ['waiting_player', 'playing', 'complete']
  
  GameModel = Backbone.Model.extend
    idAttribute: "_id",
    
    defaults: ->
      date: new Date(),
      players: [],
      currentplayer: 0,
      status: 0,
      winner: ""
    
    ###
      Helpers
    ###  
    getNbPlayers: ->
      @get('players').length
      
    getPlayersStr: ->
      @getNbPlayers() + "/" + MAX_PLAYERS
    
    getStatusStr: ->
      STATUS[@get('status')]
      
    getDateStr: ->
      new Date(@get('date')).toUTCString()
      
    hasPlayer: (playerId) ->
      -1 isnt _.indexOf @get('players'), playerId
      
    isMaster: (playerId) ->
      0 is _.indexOf @get('players'), playerId
      
    isWaitingPlayer: ->
      'waiting_player' is @getStatusStr()
      
    isComplete: ->
      'complete' is @getStatusStr()
      
    ###
      Actions
    ###  
    canDelete: (playerId) ->
      (@isMaster playerId) and @isWaitingPlayer()
      
    canPlay: (playerId) ->
      (@hasPlayer playerId) and 'playing' is @getStatusStr()
      
    canJoin: (playerId) ->
      (!@hasPlayer playerId) and @getNbPlayers() < MAX_PLAYERS and @isWaitingPlayer()
      
    canStart: (playerId) ->
      (@isMaster playerId) and (@getNbPlayers() >= MIN_PLAYERS) and @isWaitingPlayer()
      
    canQuit: (playerId) ->
      (@hasPlayer playerId) and (@getNbPlayers() > 1) and !@isComplete()
      
      
  GameModel