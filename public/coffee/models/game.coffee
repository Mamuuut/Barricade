###
  game_model.coffee
###

define [ 'underscore', 'backbone', 'CellModel', 'barricade' ], (_, Backbone, CellModel, Barricade) ->

  GameModel = Backbone.Model.extend
    idAttribute: "_id",
    
    defaults: ->
      date: new Date()
      players: []
      currentplayer: 0
      status: 0
      winner: ""
    
    ###
      Helpers
    ###  
    getNbPlayers: ->
      @get('players').length
      
    getPlayersStr: ->
      @getNbPlayers() + "/" + Barricade.maxPlayers
    
    getStatusStr: ->
      Barricade.status[@get('status')]
      
    getDateStr: ->
      new Date(@get('date')).toUTCString()
      
    hasPlayer: (playerId) ->
      -1 isnt _.indexOf @get('players'), playerId
      
    getTurnColor: ->
      Barricade.colors[@get('turn').player]
    
    getPawn: (posStr) ->
      pawnColor = undefined
      _.each @get('pawns'), (pawns, color) ->
        if -1 isnt _.indexOf pawns, posStr
          pawnColor = color
      pawnColor
      
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
      (!@hasPlayer playerId) and (@getNbPlayers() < Barricade.maxPlayers) and @isWaitingPlayer()
      
    canStart: (playerId) ->
      (@isMaster playerId) and (@getNbPlayers() >= Barricade.minPlayers) and @isWaitingPlayer()
      
    canQuit: (playerId) ->
      (@hasPlayer playerId) and (@getNbPlayers() > 1) and !@isComplete()

  GameModel