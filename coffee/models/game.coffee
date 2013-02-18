###
  game_model.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
  ###
    Static rules
  ###
  MIN_PLAYERS = 2
  MAX_PLAYERS = 4
  STATUS = ['waiting_player', 'playing', 'complete']
  COLORS = ['red', 'green', 'yellow', 'blue']
  BOARD = [
    [8],
    [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],
    [0,16],
    [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],
    [8],
    [6,7,8,9,10],
    [6,10],
    [4,5,6,7,8,9,10,11,12],
    [4,12],
    [2,3,4,5,6,7,8,9,10,11,12,13,14],
    [2,6,10,14],
    [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],
    [0,4,8,12,16],
    [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],
    [1,2,3,5,6,7,9,10,11,13,14,15],
    [1,2,3,5,6,7,9,10,11,13,14,15],
    [1,3,5,7,9,11,13,15],
  ]
  EXIT = "8:0"
  START = 
    red: "2:13",
    green: "6:13",
    yellow: "10:13",
    blue: "14:13"
  HOUSES = 
    red: ["1:14","2:14","3:14","1:15","2:15","3:15","1:16","3:16"],
    green: ["5:14","6:14","7:14","5:15","6:15","7:15","5:16","7:16"],
    yellow: ["9:14","10:14","11:14","9:15","10:15","11:15","9:16","11:16"],
    blue: ["13:14","14:14","15:14","13:15","14:15","15:15","13:16","15:16"]
  
  GameModel = Backbone.Model.extend
    idAttribute: "_id",
    
    defaults: ->
      date: new Date(),
      players: [],
      currentplayer: 0,
      status: 0,
      winner: "",
      pawns:
        red: _.clone(HOUSES.red),
        green: _.clone(HOUSES.green),
        yellow: _.clone(HOUSES.yellow),
        blue: _.clone(HOUSES.blue),
        black: ["8:1","8:3","8:4","8:5","6:7","10:7","0:11","4:11","8:11","12:11","16:11"]
    
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
      
  GameModel.COLORS = COLORS
  GameModel.BOARD = BOARD
  GameModel.getCellClass = (pos) ->
    cellClass = undefined
    if EXIT is pos
      cellClass = 'exit'
    _.each START, (start, color) ->
      if start is pos
        cellClass = 'start ' + color
    _.each HOUSES, (house, color) ->
      if -1 isnt _.indexOf house, pos 
        cellClass = 'house ' + color
    cellClass
  GameModel