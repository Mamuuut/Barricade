
define [ 'underscore', 'backbone', 'barricade' ], (_, Backbone, Barricade) ->
   
  posObjectToStr = (posObject) ->
    posObject.x + ':' + posObject.y 
    
  posStrToObject = (posStr) ->
    posArray = posStr.split ':'
    {
      x: parseInt(posArray[0]),
      y: parseInt(posArray[1])
    }
  
  getStart = (color) ->
    Barricade.start[color]
  
  getStartColor = (posStr) ->
    color = undefined
    _.each Barricade.start, (startPosStr, startColor) ->
      if startPosStr is posStr
        color = startColor
    color
  
  getHouseColor = (posStr) ->
    color = undefined
    _.each Barricade.houses, (houses, houseColor) ->
      if -1 isnt _.indexOf houses, posStr
        color = houseColor
    color
    
  CellModel = Backbone.Model.extend
    
    defaults: ->
      type: 'normal',
      color: undefined,
      pawn: undefined,
      source: undefined,
      target: undefined,
      hoverable: false,
      neighbours: []
      pos: 
        x: 0,
        y: 0
        
    initialize: ->
      posStr = @getPosStr()
      startColor = getStartColor posStr
      houseColor = getHouseColor posStr
      if Barricade.exit is posStr
        @set 'type', 'exit' 
      else if startColor
        @set 'type', 'start'
        @set 'color', startColor
      else if houseColor
        @set 'type', 'house'
        @set 'color', houseColor
    
    reset: ->
      @set 
        hoverable: false,
        pawn: undefined,
        source: undefined,
        target: undefined
    
    isExit: ->
      'exit' is @get 'type'
    
    isHouse: ->
      'house' is @get 'type'
    
    isEmpty: ->
      (!@get 'pawn') and !@isHouse()
    
    isBarricade: ->
      'barricade' is @get 'pawn'
    
    getPosStr: ->
      posObjectToStr @get('pos')

  CellModel.getStart        = getStart
  CellModel.posStrToObject  = posStrToObject
  CellModel