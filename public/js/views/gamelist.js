// Generated by CoffeeScript 1.3.3

/*
  gamelist.coffee
*/


(function() {

  define(['backbone', 'GameLineView'], function(Backbone, GameLineView) {
    var GameListView;
    GameListView = Backbone.View.extend({
      el: $("#games"),
      initialize: function() {
        this.games = this.options.games;
        this.playerid = this.options.playerid;
        this.list = this.$('.list');
        return this.games.on('add', this.addGame, this);
      },
      events: {
        "click #create": "createGame"
      },
      render: function() {
        var _this = this;
        this.list.empty();
        return this.games.each(function(game) {
          return _this.addGame(game);
        });
      },
      addGame: function(game) {
        var line;
        line = new GameLineView({
          model: game
        });
        line.render();
        return this.list.append(line.$el);
      },
      createGame: function() {
        return this.games.create({
          players: [this.playerid],
          currentplayer: 0,
          cells: [0, 0, 0, 0, 0, 0, 0, 0, 0]
        }, {
          wait: true
        });
      }
    });
    return GameListView;
  });

}).call(this);
