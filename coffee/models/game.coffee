###
  game_model.coffee
###

define [ 'underscore', 'backbone' ], (_, Backbone) ->
  GameModel = Backbone.Model.extend
    idAttribute: "_id",
    
    url: ->
      '/todo/' + @id
    ,
    
    defaults: ->
      date: new Date(),
      players: [],
      currentplayer: 0,
      cells: []
      
  GameModel