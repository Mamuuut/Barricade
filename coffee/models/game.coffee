###
  game_model.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
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
      
    hasPlayer: (playerId) ->
      -1 isnt _.indexOf @get('players'), playerId
      
  GameModel