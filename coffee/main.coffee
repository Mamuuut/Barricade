###
  main.coffee
###

requirejs.config
  paths: 
    underscore: 'libs/underscore-min',
    backbone: 'libs/backbone-min'

require ['app'], (App) ->
    App.initialize()
