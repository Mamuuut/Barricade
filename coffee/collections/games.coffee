###
  game_list.coffee
###

define [ 'underscore', 'backbone', 'GameModel' ], (_, Backbone, GameModel) ->
  GameList = Backbone.Collection.extend
    
    model: GameModel,
    url: '/games'
      
  GameList