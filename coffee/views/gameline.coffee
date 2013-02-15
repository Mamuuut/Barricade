###
  gameline.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
  GameLineView = Backbone.View.extend
    tagName: 'li',  
    
    template: _.template($('#game-template').html()),
     
    initialize: ->
      @playerid = @options.playerid
     
    events: 
      "click .delete": "deleteGame"
    
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
            
    deleteGame: ->
      @model.destroy( {
        success: (model, response) =>
          @$el.remove()
      } )
     
  GameLineView