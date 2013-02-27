
define [ 'backbone', 'CellView', 'CellGrid', 'CellModel', 'barricade' ], (Backbone, CellView, CellGrid, CellModel, Barricade) ->
  
  DICE_CLASSES = ['one', 'two', 'three', 'four', 'five', 'six']
  
  BoardView = Backbone.View.extend
    el: $("#board_container"),  
    socket: null,
     
    initialize: ->
      @socket = @options.socket
      @socket.on 'update board', (res) =>
        @model.fetch()
        
      @socket.on 'game winner', (winnerId) =>
        @onGameWinner winnerId
      
      @playerId = @options.playerid
      
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
      
      @cells.setTurn turn, @model.isCurrentPlayer(@playerId)
      
    play: (game) -> 
      @$('#win').hide()
      
      @socket.emit 'play', game.id
      @cells.reset()
      @model = game
      
      @model.on 'change:status',  @onStatusChanged, @
      @model.on 'change:pawns',   @updatePawns, @
      @model.on 'change:turn',    @updatePlayerTurn, @
      
      @updatePawns()
      @updatePlayerTurn()
        
    backToGameList: ->
      @socket.emit 'stop'
      @trigger 'back'
    
    onMove: (move) ->
      @socket.emit 'move', move
      
    onGameWinner: (winnerId) ->
      if winnerId is @playerId
        @$('.win').show()
        @$('.lose').hide()
        @$('#end').show()
      else
        @$('.win').hide()
        @$('.lose').show()
        @$('#end').show()
      
  BoardView