
define [ 'backbone', 'GameModel' ], (Backbone, GameModel) ->
  CELL_WIDTH = 30
  CELL_HEIGHT = 30
  MARGIN = 45
  DICE_CLASSES = ['one', 'two', 'three', 'four', 'five', 'six']
  
  BoardView = Backbone.View.extend
    el: $("#board_container"),  
    boardSocket: null,
    hoveredCell: null,
    cells: {},
    pawns: {},
     
    initialize: ->
      @playerid = @options.playerid
      @boardSocket = io.connect('/game_list')

    events: 
      "click .back":            "backToGameList",  
      "click .pawn.hoverable":  "pawnSelected"
    
    render: ->
      @drawCells()
      @drawPawns()
    
    drawCells: ->
      _.each GameModel.BOARD, (line, j) =>
        _.each line, (i) =>
          cellClass = GameModel.getCellClass i + ":" + j
          posStr = i + ':' + j
          @cells[posStr] = @drawOne i, j, cellClass
          
    drawPawns: ->
      _.each (@model.get 'pawns'), (pawns, pawnClass) =>
        _.each pawns, (posStr) =>
          pos = posStr.split ':'
          @pawns[posStr] = @drawOne pos[0], pos[1], 'pawn ' + pawnClass
    
    drawOne: (i, j, cellClass) ->
      x = MARGIN + CELL_WIDTH * i
      y = MARGIN + CELL_WIDTH * j
      cell = $ '<div/>'
      cell.addClass 'cell'
      cell.addClass cellClass
      cell.css
        width: CELL_WIDTH + 'px',
        height: CELL_HEIGHT + 'px',
        left: x + 'px',
        top: y + 'px'
      @$('#board').append cell
      cell.data 'pos', (i + ':' + j)
      cell
    
    updatePlayerTurn: ->
      color = GameModel.COLORS[@model.get('turn').player]
      @$('#turn').removeClass()
      @$('#turn').addClass color
      
      diceClass = DICE_CLASSES[@model.get('turn').dice]
      @$('#dice').removeClass()
      @$('#dice').addClass diceClass
      
      @$('.pawn').removeClass 'hoverable'
      @$('.pawn.' + color).addClass 'hoverable'
      
    play: (game) -> 
      @$('.pawn').removeClass 'selected'
      @$('.cell').removeClass 'target'
      @model = game
      @render()
      @updatePlayerTurn()
        
    pawnSelected: (event) ->
      @$('.pawn').removeClass 'selected'
      @$('.cell').removeClass 'target'
      pawn = $(event.currentTarget) 
      pawn.addClass 'selected'
      moves = @model.getMoves pawn.data('pos')
      _.each moves, (posStr) =>
        @cells[posStr].addClass 'target'
        
    backToGameList: ->
      @trigger 'back'
      
  BoardView