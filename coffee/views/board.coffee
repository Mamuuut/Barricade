
define [ 'backbone', 'GameModel' ], (Backbone, GameModel) ->
  CELL_WIDTH = 30
  CELL_HEIGHT = 30
  MARGIN = 45
  COLORS = ['#000000', "#ff0000", "00ff00", "ffff00", "0000ff"]
  
  BoardView = Backbone.View.extend
    el: $("#board_container"),  
    boardSocket: null,
     
    initialize: ->
      @playerid = @options.playerid
      if @$('canvas')[0].getContext and @$('canvas')[0].getContext '2d'
        @context = @$('canvas')[0].getContext '2d'
      @boardSocket = io.connect('/game_list')

    events: 
      "click .back":  "backToGameList",
    
    render: ->
      if @context 
        @drawCells()
        @drawPawns()
    
    drawCells: ->
      _.each GameModel.BOARD, (line, j) =>
        _.each line, (i) =>
          @drawCell i, j, "#ffffff"
    
    drawPawns: ->
      _.each (@model.get 'pawns'), (pawns, pawnId) =>
        _.each pawns, (posStr) =>
          pos = posStr.split ':'
          @drawCell pos[0], pos[1], COLORS[pawnId]
    
    drawCell: (i,j,color) ->
      x = MARGIN + CELL_WIDTH * i
      y = MARGIN + CELL_WIDTH * j
      @context.fillStyle = color
      @context.fillRect x, y, CELL_WIDTH, CELL_HEIGHT
    
    play: (game) -> 
      @model = game
      @render()
      
    backToGameList: ->
      @trigger 'back'
   
  BoardView