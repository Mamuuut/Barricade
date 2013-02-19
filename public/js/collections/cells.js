// Generated by CoffeeScript 1.3.3
(function() {

  define(['backbone', 'CellModel'], function(Backbone, CellModel) {
    var CellGrid;
    CellGrid = Backbone.Collection.extend({
      model: CellModel,
      turn: void 0,
      selected: void 0,
      initialize: function() {
        return this.on('change:selected', this.onSelected, this);
      },
      initializeNeighbours: function() {
        var _this = this;
        return this.each(function(cell) {
          return cell.set({
            neighbours: _this.getNeighbours(cell)
          });
        });
      },
      getStart: function(color) {
        var pos, posStr;
        posStr = CellModel.getStart(color);
        pos = CellModel.posStrToObject(posStr);
        return this.getCells(pos.x, pos.y)[0];
      },
      getCells: function(x, y) {
        return this.filter(function(cell) {
          var pos;
          pos = cell.get('pos');
          return !cell.isHouse() && pos.x === x && pos.y === y;
        });
      },
      getTurnColor: function() {
        return CellModel.PAWNS[this.turn.player];
      },
      getNeighbours: function(cell) {
        var neighbours, pos;
        neighbours = [];
        pos = cell.get('pos');
        if (cell.isHouse()) {
          pos = this.getStart(cell.get('color')).get('pos');
        }
        neighbours = neighbours.concat(this.getCells(pos.x, pos.y - 1));
        neighbours = neighbours.concat(this.getCells(pos.x - 1, pos.y));
        neighbours = neighbours.concat(this.getCells(pos.x, pos.y + 1));
        return neighbours.concat(this.getCells(pos.x + 1, pos.y));
      },
      onSelected: function(cell, selected) {
        var targets,
          _this = this;
        if (selected) {
          if (this.selected) {
            this.selected.set({
              selected: false
            });
          }
          this.selected = cell;
          this.clearTargets();
          targets = this.getTargets(cell);
          return _.each(targets, function(target) {
            return target.set({
              targeted: true
            });
          });
        }
      },
      getTargets: function(cell, nbMoves, accepted, rejected) {
        var neighbours,
          _this = this;
        nbMoves = nbMoves != null ? nbMoves : this.turn.dice;
        if (cell.isHouse()) {
          return this.getTargets(this.getStart(cell.get('color')), nbMoves - 1);
        }
        accepted = accepted || [];
        rejected = rejected || [cell.getPosStr()];
        neighbours = cell.get('neighbours');
        _.each(neighbours, function(neighbour) {
          if (-1 === _.indexOf(rejected, neighbour.getPosStr())) {
            if (nbMoves !== 0) {
              if (!neighbour.isBarricade()) {
                rejected.push(neighbour.getPosStr());
                return _this.getTargets(neighbour, nbMoves - 1, accepted, rejected);
              }
            } else if (neighbour.get('pawn') !== _this.getTurnColor()) {
              return accepted.push(neighbour);
            }
          }
        });
        return accepted;
      },
      clearTargets: function() {
        var targets;
        targets = this.where({
          targeted: true
        });
        return _.each(targets, function(target) {
          return target.set({
            targeted: false
          });
        });
      },
      setTurn: function(turn) {
        var _this = this;
        this.turn = turn;
        return this.each(function(cell) {
          var isHoverable;
          isHoverable = _this.getTurnColor() === cell.get('pawn');
          return cell.set({
            hoverable: isHoverable
          });
        });
      }
    });
    return CellGrid;
  });

}).call(this);
