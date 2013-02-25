// Generated by CoffeeScript 1.3.3
(function() {

  define(['backbone', 'CellView', 'CellGrid', 'CellModel', 'barricade'], function(Backbone, CellView, CellGrid, CellModel, Barricade) {
    var BoardView, DICE_CLASSES;
    DICE_CLASSES = ['one', 'two', 'three', 'four', 'five', 'six'];
    BoardView = Backbone.View.extend({
      el: $("#board_container"),
      boardSocket: null,
      initialize: function() {
        var _this = this;
        this.boardSocket = io.connect();
        this.boardSocket.on('move', function(res) {
          _this.model.fetch();
          return console.log('move result', res);
        });
        this.playerId = this.options.playerid;
        this.cells = new CellGrid();
        _.each(Barricade.cells, function(line, y) {
          return _.each(line, function(x) {
            return _this.cells.push(new CellModel({
              pos: {
                x: x,
                y: y
              }
            }));
          });
        });
        this.cells.initializeNeighbours();
        this.cells.on('move', this.onMove, this);
        return this.render();
      },
      events: {
        "click .back": "backToGameList"
      },
      render: function() {
        var _this = this;
        this.$('.cell').remove();
        return this.cells.each(function(cell) {
          var cellView;
          cellView = new CellView({
            model: cell
          });
          cellView.render();
          return _this.$('#board').append(cellView.$el);
        });
      },
      updatePawns: function() {
        var _this = this;
        return this.cells.each(function(cell) {
          return cell.set('pawn', _this.model.getPawn(cell.getPosStr()));
        });
      },
      updatePlayerTurn: function() {
        var color, diceClass, turn;
        turn = this.model.get('turn');
        color = Barricade.pawns[turn.player];
        this.$('#turn').removeClass();
        this.$('#turn').addClass(color);
        diceClass = DICE_CLASSES[turn.dice - 1];
        this.$('#dice').removeClass();
        this.$('#dice').addClass(diceClass);
        return this.cells.setTurn(turn, this.model.isCurrentPlayer(this.playerId));
      },
      play: function(game) {
        this.boardSocket.emit('play', game.id);
        this.cells.reset();
        this.model = game;
        this.model.on('change:pawns', this.updatePawns, this);
        this.model.on('change:turn', this.updatePlayerTurn, this);
        this.updatePawns();
        return this.updatePlayerTurn();
      },
      backToGameList: function() {
        this.boardSocket.emit('stop');
        return this.trigger('back');
      },
      onMove: function(move) {
        return this.boardSocket.emit('move', move);
      }
    });
    return BoardView;
  });

}).call(this);
