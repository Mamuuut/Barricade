
define [ 'backbone', 'CellModel' ], (Backbone, CellModel) ->
  CellGrid = Backbone.Collection.extend
    
    model: CellModel,
    selected: undefined
    
    initialize: ->
      @on 'change:selected', @onSelected, @
      
    onSelected: (model, selected)->
      if selected
        if @selected
          @selected.set {selected: false}
        @selected = model
            
    setHoverable: (color) ->
      @.each (cell) ->
        isHoverable = color is cell.get('pawn')
        cell.set('hoverable', isHoverable)  
      
  CellGrid