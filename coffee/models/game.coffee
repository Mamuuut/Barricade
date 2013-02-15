###
  game_model.coffee
###

define [ 'backbone' ], (Backbone) ->
  GameModel = Backbone.Model.extend
    idAttribute: "_id",
    
    defaults: ->
      date: new Date(),
      players: [],
      currentplayer: 0,
      status: 0
      
  GameModel