###
  game_list.coffee
###

define [ 'backbone', 'GameModel' ], (Backbone, GameModel) ->
  GameList = Backbone.Collection.extend
    
    model: GameModel,
    url: '/games'
      
  GameList