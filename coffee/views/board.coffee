
define [ 'backbone', 'GameModel', 'CellView', 'CellGrid', 'CellModel' ], (Backbone, GameModel, CellView, CellGrid, CellModel) ->
  DICE_CLASSES = ['one', 'two', 'three', 'four', 'five', 'six']
  CELLS = [
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
  
  BoardView = Backbone.View.extend
    el: $("#board_container"),  
    boardSocket: null,
     
    initialize: ->
      @playerid = @options.playerid
      @cells = new CellGrid()
      _.each CELLS, (line, y) =>
        _.each line, (x) =>
          @cells.push new CellModel(pos: {x:x, y:y})
      @render()
      
      #@boardSocket = io.connect('/game_list')

    events: 
      "click .back":            "backToGameList",  
      "click .cell.target":     "targetClick"
    
    render: ->
      @$('.cell').remove()
      @cells.each (cell) =>
        cellView = new CellView {model: cell}
        cellView.render()
        @$('#board').append cellView.$el
    
    updatePawns: ->
      @cells.each (cell) =>
        cell.set 'pawn', @model.getPawn cell.getPosStr()
    
    updatePlayerTurn: ->
      color = GameModel.COLORS[@model.get('turn').player]
      @$('#turn').removeClass()
      @$('#turn').addClass color
      
      diceClass = DICE_CLASSES[@model.get('turn').dice]
      @$('#dice').removeClass()
      @$('#dice').addClass diceClass
      
      @cells.setHoverable color
      
    play: (game) -> 
      @$('.cell').removeClass 'selected'
      @$('.cell').removeClass 'target'
      @model = game
      @updatePawns()
      @updatePlayerTurn()
        
    cellSelected: (event) ->
      @$('.cell').removeClass 'selected'
      @$('.cell').removeClass 'target'
      cell = $(event.currentTarget) 
      cell.addClass 'selected'
      moves = @model.getMoves pawn.data('pos')
      _.each moves, (posStr) =>
        @cells[posStr].addClass 'target'
    
    targetClick: (event) ->
      cell = $(event.currentTarget)
      pawn = @$ '.pawn.selected'
      @movePawn pawn, cell.data('pos')
      console.log pawn, cell.data('pos')
      @$('.pawn').removeClass 'selected'
      @$('.cell').removeClass 'target'
        
    backToGameList: ->
      @trigger 'back'
      
  BoardView