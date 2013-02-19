
define [ 'backbone', 'CellModel' ], (Backbone, CellModel) ->
  CellGrid = Backbone.Collection.extend
    
    model: CellModel,
    turn: undefined,
    selected: undefined
    
    initialize: ->
      @on 'change:selected', @onSelected, @
    
    initializeNeighbours: ->
      @each (cell) =>
        cell.set {neighbours: @getNeighbours cell}
    
    getStart: (color) ->
      posStr = CellModel.getStart color
      pos = CellModel.posStrToObject posStr
      @getCells(pos.x, pos.y)[0] 
     
    getCells: (x, y) ->
      @filter (cell) ->
        pos = cell.get('pos')
        !cell.isHouse() and pos.x is x and pos.y is y
    
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
      
    onSelected: (cell, selected)->
      if selected
        if @selected
          @selected.set {selected: false}
        @selected = cell
        @clearTargets()
        targets = @getTargets cell
        _.each targets, (target) =>
          target.set {targeted: true}
    
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
    
    clearTargets: ->
      targets = @where {targeted: true}
      _.each targets, (target) ->
        target.set {targeted: false}
            
    setTurn: (turn) ->
      @turn = turn
      @.each (cell) =>
        isHoverable = @getTurnColor() is cell.get 'pawn'
        cell.set {hoverable: isHoverable}  
      
  CellGrid