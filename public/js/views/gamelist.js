// Generated by CoffeeScript 1.3.3

/*
  gamelist.coffee
*/


(function() {

  define(['backbone', 'GameLineView'], function(Backbone, GameLineView) {
    var GameListView;
    GameListView = Backbone.View.extend({
      el: $("#games"),
      gameListSocket: null,
      initialize: function() {
        var _this = this;
        this.games = this.options.games;
        this.playerid = this.options.playerid;
        this.list = this.$('.list');
        this.games.on('reset', this.render, this);
        this.games.on('add', this.addGame, this);
        this.gameListSocket = io.connect('/game_list');
        this.gameListSocket.on('update game', function(gameId) {
          return _this.games.get(gameId).fetch();
        });
        return this.gameListSocket.on('new game', function() {
          return _this.games.fetch();
        });
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
        var line,
          _this = this;
        console.log('addGame', game);
        line = new GameLineView({
          model: game,
          playerid: this.playerid
        });
        line.render();
        line.on('join', function(gameId) {
          return _this.gameListSocket.emit('join game', gameId);
        });
        line.on('start', function(gameId) {
          return _this.gameListSocket.emit('start game', gameId);
        });
        return this.list.append(line.$el);
      },
      createGame: function() {
        var _this = this;
        return this.games.create({
          players: [this.playerid],
          currentplayer: 0,
          cells: [0, 0, 0, 0, 0, 0, 0, 0, 0]
        }, {
          wait: true,
          success: function() {
            return _this.gameListSocket.emit('new game');
          }
        });
      }
    });
    return GameListView;
  });

}).call(this);
