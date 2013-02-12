###
  game_list.coffee
###

define [ 'underscore', 'backbone', 'models/game_model' ], (_, Backbone, GameModel) ->
  GameList = Backbone.Collection.extend
    
    model: GameModel,
    url: '/games'
      
  GameList