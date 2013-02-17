
define [ 'backbone', 'GameModel' ], (Backbone, GameModel) ->
  CELL_WIDTH = 30
  CELL_HEIGHT = 30
  MARGIN = 45
  
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
          @drawCell i, j
    
    drawPawns: ->
      _.each (@model.get 'pawns'), (pawns, pawnClass) =>
        _.each pawns, (posStr) =>
          pos = posStr.split ':'
          @drawCell pos[0], pos[1], pawnClass
    
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
    
    play: (game) -> 
      @model = game
      @render()
      
    backToGameList: ->
      @trigger 'back'
      
  BoardView