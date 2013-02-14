###
  main.coffee
###

requirejs.config
  paths: 
    underscore:   'libs/underscore-min',
    backbone:     'libs/backbone-min',
    GameModel:    'models/game',
    GameList:     'collections/games',
    GameLineView: 'views/gameline',
    GameListView: 'views/gamelist'

require ['app'], (App) ->
    App.initialize()
