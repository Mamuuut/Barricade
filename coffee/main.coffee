###
  main.coffee
###

requirejs.config
  shim:
    backbone:
      deps: [ "underscore", "jquery" ],
      exports: "Backbone"
    underscore:
      exports: "_"

  paths: 
    jquery:       'libs/jquery-1.9.1.min',
    underscore:   'libs/underscore-min',
    backbone:     'libs/backbone-min',
    GameModel:    'models/game',
    GameList:     'collections/games',
    GameLineView: 'views/gameline',
    GameListView: 'views/gamelist'

require ['app'], (App) ->
    App.initialize()
