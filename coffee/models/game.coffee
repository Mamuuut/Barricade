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
      status: 0
      
    getNbPlayers: ->
      @get('players').length
      
    getPlayersStr: ->
      @getNbPlayers() + "/" + MAX_PLAYERS
    
    getStatusStr: ->
      STATUS[@get('status')]
      
    getDateStr: ->
      new Date(@get('date')).toUTCString()
      
    canPlay: (playerId) ->
      (@hasPlayer playerId) and 'playing' is @getStatusStr()
      
    canJoin: (playerId) ->
      (!@hasPlayer playerId) and @getNbPlayers() < MAX_PLAYERS
      
    canStart: (playerId) ->
      (0 is _.indexOf @get('players'), playerId) and @getNbPlayers() >= MIN_PLAYERS
      
    hasPlayer: (playerId) ->
      -1 isnt _.indexOf @get('players'), playerId
      
  GameModel