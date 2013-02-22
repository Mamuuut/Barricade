
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
      @model.on 'change:targeted',  @updateTargeted, @
      
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
      
      @pawn = @$ '.pawn'
      @target = @$ '.target'
      
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

    updateTargeted: ->
      if @model.get('targeted')
        @target.show()
      else
        @target.hide()

    updatePawn: ->
      @pawn.attr 'class', 'pawn'
      pawnClass = @model.get 'pawn'
      if pawnClass
        @pawn.addClass pawnClass
        @pawn.show()
      else
        @pawn.hide()

    cellSelected: ->
      if @model.get('hoverable')
        @model.set 'selected', true
      
  CellView