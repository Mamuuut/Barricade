
define [ 'backbone', 'CellModel', 'barricade' ], (Backbone, CellModel, Barricade) ->
  CellGrid = Backbone.Collection.extend
    
    model: CellModel,
    turn: undefined
    
    initialize: ->
      @on 'click:source:pawn', @onPawnSourceClicked, @
    
    initializeNeighbours: ->
      @each (cell) =>
        cell.set {neighbours: @getNeighbours cell}
        
    reset: ->
      @resetListener()
      @each (cell) ->
        cell.reset()
        
    resetSources: ->
      @each (cell) ->
        cell.set {source: undefined}
    
    resetTargets: ->
      @resetListener()
      @each (cell) ->
        cell.set {target: undefined}
            
    resetListener: ->
      @off 'click:target:pawn'
      @off 'click:target:barricade'
    
    # Getters/Setters    
    getBarricadeTargets: ->
      @filter (cell) ->
          cell.isEmpty() and !cell.isExit()    
         
    getCells: (x, y) ->
      @filter (cell) ->
        pos = cell.get('pos')
        !cell.isHouse() and pos.x is x and pos.y is y
    
    getStart: (color) ->
      posStr = CellModel.getStart color
      pos = CellModel.posStrToObject posStr
      @getCells(pos.x, pos.y)[0] 
    
    getTurnColor: ->
      Barricade.pawns[@turn.player]
    
    getNeighbours: (cell) ->
      neighbours = []
      pos = cell.get 'pos'
      if cell.isHouse()
        pos = @getStart(cell.get 'color').get 'pos'
      neighbours = neighbours.concat @getCells(pos.x, pos.y - 1)
      neighbours = neighbours.concat @getCells(pos.x - 1, pos.y)
      neighbours = neighbours.concat @getCells(pos.x, pos.y + 1)
      neighbours.concat @getCells(pos.x + 1, pos.y)
      
    ###
      Recursive path through neighbours
    ###
    getTargets: (cell, nbMoves, accepted, rejected) ->
      nbMoves = if nbMoves? then nbMoves else @turn.dice - 1
      if cell.isHouse()
        return @getTargets @getStart(cell.get 'color'), nbMoves - 1
      accepted = accepted or []
      rejected = rejected or [cell.getPosStr()]
      neighbours = cell.get 'neighbours'
      
      _.each neighbours, (neighbour) =>
        if -1 is _.indexOf rejected, neighbour.getPosStr()
          if nbMoves isnt 0
            if !neighbour.isBarricade()
              rejected.push neighbour.getPosStr()
              @getTargets neighbour, nbMoves - 1, accepted, rejected
          else if neighbour.get('pawn') isnt @getTurnColor()
            accepted.push neighbour
      accepted
            
    setTurn: (turn) ->
      @turn = turn
      @.each (cell) =>
        isHoverable = @getTurnColor() is cell.get 'pawn'
        cell.set {hoverable: isHoverable}  
    
    # Listeners  
    onPawnSourceClicked: (cell)->
      @resetSources()
      @resetTargets()
      cell.set {source: 'move-pawn'}
      targets = @getTargets cell
      _.each targets, (target) =>
        target.set {target: 'move-pawn'}
      @on 'click:target:pawn', @onPawnTargetClicked, @
    
    onPawnTargetClicked: (cell) ->
      if cell.isBarricade()
        @resetTargets()
        cell.set {source: 'move-barricade'}
        _.each @getBarricadeTargets(), (target) ->
          target.set {target: 'move-barricade'}
        @on 'click:target:barricade', @onBarricadeTargetClicked, @
      else
        @resetTargets()
        @resetSources()
        @trigger 'move', 'pawn'
      
    onBarricadeTargetClicked: (cell) ->
      @resetTargets()
      @resetSources()
      @trigger 'move', 'pawn+barricade'
      
  CellGrid