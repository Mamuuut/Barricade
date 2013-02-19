###
  game_model.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
  
  TYPES = ['normal', 'exit', 'start', 'house']
  PAWNS = ['red', 'green', 'yellow', 'blue', 'barricade']
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
   
  posArrayToStr = (posArray) ->
    posArray.x + ':' + posArray.y 
  
  getStart = (posStr) ->
    color = undefined
    _.each START, (startPosStr, startColor) ->
      if startPosStr is posStr
        color = startColor
    color
  
  getHouse = (posStr) ->
    color = undefined
    _.each HOUSES, (houses, houseColor) ->
      if -1 isnt _.indexOf houses, posStr
        color = houseColor
    color
    
  CellModel = Backbone.Model.extend
    
    defaults: ->
      type: 'normal',
      color: undefined,
      pawn: undefined,
      hoverable: false,
      selected: false,
      pos: 
        x: 0,
        y: 0
        
    initialize: ->
      posStr = @getPosStr()
      startColor = getStart posStr
      houseColor = getHouse posStr
      if EXIT is posStr
        @set 'type', 'exit' 
      else if startColor
        @set 'type', 'start'
        @set 'color', startColor
      else if houseColor
        @set 'type', 'house'
        @set 'color', houseColor

    getPosStr: ->
      posArrayToStr @get('pos')

  CellModel.HOUSES = HOUSES      
  CellModel