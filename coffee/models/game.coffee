###
  game_model.coffee
###

define [ 'underscore', 'backbone', 'CellModel' ], (_, Backbone, CellModel) ->
  ###
    Static
  ###
  MIN_PLAYERS = 2
  MAX_PLAYERS = 4
  STATUS = ['waiting_player', 'playing', 'complete']
  COLORS = ['red', 'green', 'yellow', 'blue']

  ###
    GameModel
  ###
  GameModel = Backbone.Model.extend
    idAttribute: "_id",
    
    defaults: ->
      date: new Date(),
      players: [],
      currentplayer: 0,
      status: 0,
      winner: "",
      pawns:
        red: _.clone CellModel.HOUSES.red
        green: _.clone CellModel.HOUSES.green
        yellow: _.clone CellModel.HOUSES.yellow
        blue: _.clone CellModel.HOUSES.blue
        barricade: ["8:1","8:3","8:4","8:5","6:7","10:7","0:11","4:11","8:11","12:11","16:11"]
    
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
      
    getTurnColor: ->
      COLORS[@get('turn').player]
    
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
      Board move
    ###
      
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

  GameModel.COLORS = COLORS
  GameModel