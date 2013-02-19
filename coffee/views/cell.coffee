
define [ 'underscore', 'backbone' ], (_, Backbone) ->
  CELL_WIDTH = 30
  CELL_HEIGHT = 30
  MARGIN = 45
  
  CellView = Backbone.View.extend
    tagName: 'div',  
    className: "cell",
    
    template: _.template($('#cell-template').html()),
     
    initialize: -> 
      @model.on 'change:pawn',      @updatePawn, @
      @model.on 'change:hoverable', @updateHoverable, @
      @model.on 'change:selected',  @updateSelected, @
      
    events: 
      "click":  "cellSelected", 
    
    render: -> 
      @$el.html @template()
      
      left = MARGIN + CELL_WIDTH * @model.get('pos').x
      top = MARGIN + CELL_HEIGHT * @model.get('pos').y 
      
      @$el.css
        width: CELL_WIDTH + 'px',
        height: CELL_HEIGHT + 'px',
        left: left + 'px',
        top: top + 'px',
      
      @$el.addClass @model.get 'type'
      @$el.addClass @model.get 'color'
      
      @updatePawn()
    
    updateHoverable: ->
      if @model.get('hoverable')
        @$el.addClass 'hoverable'
      else
        @$el.removeClass 'hoverable'
    
    updateSelected: ->
      if @model.get('selected')
        @$el.addClass 'selected'
      else
        @$el.removeClass 'selected'

    updatePawn: ->
      pawn = @model.get 'pawn'
      if pawn
        @$('div').addClass pawn
        @$('div').show()
      else
        @$('div').hide()

    cellSelected: ->
      @model.set 'selected', true
      
  CellView