
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
      @model.on 'change:source',    @updateSource, @
      @model.on 'change:target',    @updateTarget, @
      
    events: 
      "click":  "cellClicked", 
      "dblclick":  "cellDblClicked", 
    
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
      if @model.get 'hoverable'
        @$el.addClass 'hoverable'
      else
        @$el.removeClass 'hoverable'
    
    updateSource: ->
      @$el.removeClass 'move-pawn move-barricade'
      sourceClass = @model.get 'source'
      if sourceClass
        @$el.addClass sourceClass
      
    updateTarget: ->
      @target.attr 'class', 'target'
      targetClass = @model.get 'target'
      if targetClass
        @target.addClass targetClass
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

    cellClicked: ->
      if @model.get 'hoverable'
        @model.trigger 'click:source:pawn', @model
      if 'move-pawn' is @model.get 'target'
        @model.trigger 'click:target:pawn', @model
      if 'move-barricade' is @model.get 'target'
        @model.trigger 'click:target:barricade', @model
        
    cellDblClicked: ->
      @model.trigger 'click:target:pawn', @model
      
  CellView