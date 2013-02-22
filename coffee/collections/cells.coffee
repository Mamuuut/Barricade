
define [ 'backbone', 'CellModel' ], (Backbone, CellModel) ->
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
    getEmptyCells: ->
      @filter (cell) ->
          cell.isEmpty()     
         
    getCells: (x, y) ->
      @filter (cell) ->
        pos = cell.get('pos')
        !cell.isHouse() and pos.x is x and pos.y is y
    
    getStart: (color) ->
      posStr = CellModel.getStart color
      pos = CellModel.posStrToObject posStr
      @getCells(pos.x, pos.y)[0] 
    
    getTurnColor: ->
      CellModel.PAWNS[@turn.player]
    
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
      nbMoves = if nbMoves? then nbMoves else @turn.dice
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
      console.log targets
      _.each targets, (target) =>
        target.set {target: 'move-pawn'}
      @on 'click:target:pawn', @onPawnTargetClicked, @
    
    onPawnTargetClicked: (cell) ->
      console.log 'onPawnTargetClicked', cell.get 'pos'
      if cell.isBarricade()
        @resetTargets()
        cell.set {source: 'move-barricade'}
        @on 'click:target:barricade', @onBarricadeTargetClicked, @
        _.each @getEmptyCells(), (target) ->
          target.set {target: 'move-barricade'}
      else
        @resetTargets()
        @resetSources()
      
    onBarricadeTargetClicked: (cell) ->
      console.log 'onBarricadeTargetClicked', cell.get 'pos'
      @resetTargets()
      @resetSources()
      
  CellGrid