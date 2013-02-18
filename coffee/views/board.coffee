
define [ 'backbone', 'GameModel' ], (Backbone, GameModel) ->
  CELL_WIDTH = 30
  CELL_HEIGHT = 30
  MARGIN = 45
  DICE_CLASSES = ['one', 'two', 'three', 'four', 'five', 'six']
  
  BoardView = Backbone.View.extend
    el: $("#board_container"),  
    boardSocket: null,
    hoveredCell: null
     
    initialize: ->
      @playerid = @options.playerid
      @boardSocket = io.connect('/game_list')

    events: 
      "click .back":  "backToGameList"  
    
    render: ->
      @drawCells()
      @drawPawns()
    
    drawCells: ->
      _.each GameModel.BOARD, (line, j) =>
        _.each line, (i) =>
          cellClass = GameModel.getCellClass i + ":" + j
          @drawCell i, j, cellClass
    
    drawPawns: ->
      _.each (@model.get 'pawns'), (pawns, pawnClass) =>
        _.each pawns, (posStr) =>
          pos = posStr.split ':'
          @drawCell pos[0], pos[1], 'pawn ' + pawnClass
    
    drawCell: (i, j, cellClass) ->
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
    
    updatePlayerTurn: ->
      color = GameModel.COLORS[@model.get('turn').player]
      @$('#turn').removeClass()
      @$('#turn').addClass color
      
      diceClass = DICE_CLASSES[@model.get('turn').dice]
      @$('#dice').removeClass()
      @$('#dice').addClass diceClass
      
    play: (game) -> 
      @model = game
      @render()
      @updatePlayerTurn()
      
    backToGameList: ->
      @trigger 'back'
      
  BoardView