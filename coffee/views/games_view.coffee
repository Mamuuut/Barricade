###
  games_view.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
  GamesView = Backbone.View.extend
    el: $("#games"),  
     
    initialize: ->
      @games = @options.games
      @playerid = @options.playerid
     
    events: 
      "click #create": "createGame"
      
    createGame: ->
      @games.create 
        players: [@playerid],
        currentplayer: 0,
        cells: [0,0,0,0,0,0,0,0,0]
     
  GamesView