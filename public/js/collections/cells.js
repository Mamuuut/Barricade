// Generated by CoffeeScript 1.3.3
(function() {

  define(['backbone', 'CellModel'], function(Backbone, CellModel) {
    var CellGrid;
    CellGrid = Backbone.Collection.extend({
      model: CellModel,
      turn: void 0,
      initialize: function() {
        return this.on('click:source:pawn', this.onPawnSourceClicked, this);
      },
      initializeNeighbours: function() {
        var _this = this;
        return this.each(function(cell) {
          return cell.set({
            neighbours: _this.getNeighbours(cell)
          });
        });
      },
      reset: function() {
        this.resetListener();
        return this.each(function(cell) {
          return cell.reset();
        });
      },
      resetSources: function() {
        return this.each(function(cell) {
          return cell.set({
            source: void 0
          });
        });
      },
      resetTargets: function() {
        this.resetListener();
        return this.each(function(cell) {
          return cell.set({
            target: void 0
          });
        });
      },
      resetListener: function() {
        this.off('click:target:pawn');
        return this.off('click:target:barricade');
      },
      getEmptyCells: function() {
        return this.filter(function(cell) {
          return cell.isEmpty();
        });
      },
      getCells: function(x, y) {
        return this.filter(function(cell) {
          var pos;
          pos = cell.get('pos');
          return !cell.isHouse() && pos.x === x && pos.y === y;
        });
      },
      getStart: function(color) {
        var pos, posStr;
        posStr = CellModel.getStart(color);
        pos = CellModel.posStrToObject(posStr);
        return this.getCells(pos.x, pos.y)[0];
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
      /*
            Recursive path through neighbours
      */

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
      },
      onPawnSourceClicked: function(cell) {
        var targets,
          _this = this;
        this.resetSources();
        this.resetTargets();
        cell.set({
          source: 'move-pawn'
        });
        targets = this.getTargets(cell);
        console.log(targets);
        _.each(targets, function(target) {
          return target.set({
            target: 'move-pawn'
          });
        });
        return this.on('click:target:pawn', this.onPawnTargetClicked, this);
      },
      onPawnTargetClicked: function(cell) {
        console.log('onPawnTargetClicked', cell.get('pos'));
        if (cell.isBarricade()) {
          this.resetTargets();
          cell.set({
            source: 'move-barricade'
          });
          this.on('click:target:barricade', this.onBarricadeTargetClicked, this);
          return _.each(this.getEmptyCells(), function(target) {
            return target.set({
              target: 'move-barricade'
            });
          });
        } else {
          this.resetTargets();
          return this.resetSources();
        }
      },
      onBarricadeTargetClicked: function(cell) {
        console.log('onBarricadeTargetClicked', cell.get('pos'));
        this.resetTargets();
        return this.resetSources();
      }
    });
    return CellGrid;
  });

}).call(this);
