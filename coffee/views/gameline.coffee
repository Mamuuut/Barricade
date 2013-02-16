###
  gameline.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
  GameLineView = Backbone.View.extend
    tagName: 'li',  
    
    template: _.template($('#game-template').html()),
     
    initialize: ->
      @playerid = @options.playerid
      @model.on 'change', @updateLine, @
     
    events: 
      "click .delete":  "deleteGame",
      "click .join":    "joinGame",
      "click .start":   "startGame"
    
    ###
      Rendering
    ### 
    render: ->
      params = 
        status: @model.get('status'), 
        date: @model.getDateStr() 
      @$el.html @template(params)
      @updateLine()
    
    updateLine: ->
      @updateNbPlayers()
      @updateStatus()
      @updateJoinBtn()
      @updatePlayBtn()
      @updateStartBtn()
      @updateDeleteBtn()
    
    updateDeleteBtn: ->
      if @model.canDelete @playerid
        @$('.delete').show()
      else
        @$('.delete').hide()
    
    updateStartBtn: ->
      if @model.canStart @playerid
        @$('.start').show()
      else
        @$('.start').hide()
    
    updateJoinBtn: ->
      if @model.canJoin @playerid
        @$('.join').show()
      else
        @$('.join').hide()
    
    updatePlayBtn: ->
      if @model.canPlay @playerid
        @$('.play').show()
      else
        @$('.play').hide()

    updateNbPlayers: ->
      @$('.players').html @model.getPlayersStr() 
    
    updateStatus: ->
      @$el.addClass @model.getStatusStr()
    
    ###
      Event handlers
    ###        
    deleteGame: ->
      @model.destroy( {
        success: (model, response) =>
          @$el.remove()
      } )   
         
    joinGame: ->
      @trigger 'join', @model.id
         
    startGame: ->
      @trigger 'start', @model.id
     
  GameLineView