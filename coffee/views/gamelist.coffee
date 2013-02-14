###
  gamelist.coffee
###

define [ 'underscore', 'backbone', 'GameLineView' ], (_, Backbone, GameLineView) ->
  GameListView = Backbone.View.extend
    el: $("#games"),  
    
    template: _.template($('#game-template').html()),
     
    initialize: ->
      @games = @options.games
      @playerid = @options.playerid
      @list = @.$ '.list'
      @games.on 'change', @render, @
     
    events: 
      "click #create": "createGame"
    
    render: ->
      @list.empty()
      @games.each (game) =>
        @renderGame game
      
    renderGame: (game) ->
      line = new GameLineView { model: game }
      line.render()
      @list.append line.$el
            
    createGame: ->
      @games.create 
        players: [@playerid],
        currentplayer: 0,
        cells: [0,0,0,0,0,0,0,0,0]
     
  GameListView