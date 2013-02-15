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
      @updateNbPlayers()
      @updateStatus()
      @updateJoinBtn()
      @updateOpenBtn()
    
    updateJoinBtn: ->
      if @model.hasPlayer @playerid
        @$('.join').hide()
      else
        @$('.join').show()
    
    updateOpenBtn: ->
      if @model.hasPlayer @playerid
        @$('.open').show()
      else
        @$('.open').hide()

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