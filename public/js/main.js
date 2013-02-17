// Generated by CoffeeScript 1.3.3

/*
  main.coffee
*/


(function() {

  requirejs.config({
    shim: {
      backbone: {
        deps: ["underscore", "jquery"],
        exports: "Backbone"
      },
      underscore: {
        exports: "_"
      }
    },
    paths: {
      jquery: 'libs/jquery-1.9.1.min',
      underscore: 'libs/underscore-min',
      backbone: 'libs/backbone-min',
      GameModel: 'models/game',
      GameList: 'collections/games',
      GameLineView: 'views/gameline',
      GameListView: 'views/gamelist',
      BoardView: 'views/board',
      MainView: 'views/main',
      ChatView: 'views/chat'
    }
  });

  require(['app'], function(App) {
    return App.initialize();
  });

}).call(this);
