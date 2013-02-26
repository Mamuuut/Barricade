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
      "click .start":   "startGame",
      "click .quit":    "quitGame",
      "click .play":    "playGame"
    
    ###
      Rendering
    ### 
    render: ->
      @$el.html @template()
      @updateLine()
    
    updateLine: ->
      @updateNbPlayers()
      @updateTitle()
      @updateStatus()
      
      @updateJoinBtn()
      @updatePlayBtn()
      @updateStartBtn()
      @updateDeleteBtn()
      @updateQuitBtn()
    
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
    
    updateQuitBtn: ->
      if @model.canQuit @playerid
        @$('.quit').show()
      else
        @$('.quit').hide()

    updateNbPlayers: ->
      @$('.players').html @model.getPlayersStr() 
    
    updateStatus: ->
      @$el.addClass @model.getStatusStr()
    
    updateTitle: ->
      names = @model.get 'playerNames'
      @$('.title').empty()
      _.each names, (name, idx) =>
        span = $('<span>' + name + '</span>')
        if idx is @model.get('turn').player
          span.addClass 'current'
        @$('.title').append span
    
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
         
    quitGame: ->
      @trigger 'quit', @model.id
         
    playGame: ->
      @trigger 'play', @model
     
  GameLineView