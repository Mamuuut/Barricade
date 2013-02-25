
define [ 'backbone', 'CellView', 'CellGrid', 'CellModel', 'barricade' ], (Backbone, CellView, CellGrid, CellModel, Barricade) ->
  
  DICE_CLASSES = ['one', 'two', 'three', 'four', 'five', 'six']
  
  BoardView = Backbone.View.extend
    el: $("#board_container"),  
    boardSocket: null,
     
    initialize: ->
      @boardSocket = io.connect()
      @boardSocket.on 'move', (res) =>
        @model.fetch()
        console.log 'move result', res
      
      @playerid = @options.playerid
      
      @cells = new CellGrid()
      _.each Barricade.cells, (line, y) =>
        _.each line, (x) =>
          @cells.push new CellModel(pos: {x:x, y:y})
      @cells.initializeNeighbours()
      @cells.on 'move', @onMove, @
      
      @render()

    events: 
      "click .back": "backToGameList",  
    
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
      turn = @model.get('turn')
      color = Barricade.pawns[turn.player]
      @$('#turn').removeClass()
      @$('#turn').addClass color
      
      diceClass = DICE_CLASSES[turn.dice - 1]
      @$('#dice').removeClass()
      @$('#dice').addClass diceClass
      
      @cells.setTurn turn
      
    play: (game) -> 
      @boardSocket.emit 'play', game.id
      @cells.reset()
      @model = game
      
      @model.on 'change:pawns', @updatePawns, @
      @model.on 'change:turn',  @updatePlayerTurn, @
      
      @updatePawns()
      @updatePlayerTurn()
        
    backToGameList: ->
      @boardSocket.emit 'stop'
      @trigger 'back'
    
    onMove: (move) ->
      @boardSocket.emit 'move', move
      
  BoardView