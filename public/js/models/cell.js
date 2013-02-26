// Generated by CoffeeScript 1.5.0
(function() {

  define(['underscore', 'backbone', 'barricade'], function(_, Backbone, Barricade) {
    var CellModel, getHouseColor, getStart, getStartColor, posObjectToStr, posStrToObject;
    posObjectToStr = function(posObject) {
      return posObject.x + ':' + posObject.y;
    };
    posStrToObject = function(posStr) {
      var posArray;
      posArray = posStr.split(':');
      return {
        x: parseInt(posArray[0]),
        y: parseInt(posArray[1])
      };
    };
    getStart = function(color) {
      return Barricade.start[color];
    };
    getStartColor = function(posStr) {
      var color;
      color = void 0;
      _.each(Barricade.start, function(startPosStr, startColor) {
        if (startPosStr === posStr) {
          return color = startColor;
        }
      });
      return color;
    };
    getHouseColor = function(posStr) {
      var color;
      color = void 0;
      _.each(Barricade.houses, function(houses, houseColor) {
        if (-1 !== _.indexOf(houses, posStr)) {
          return color = houseColor;
        }
      });
      return color;
    };
    CellModel = Backbone.Model.extend({
      defaults: function() {
        return {
          type: 'normal',
          color: void 0,
          pawn: void 0,
          source: void 0,
          target: void 0,
          hoverable: false,
          neighbours: [],
          pos: {
            x: 0,
            y: 0
          }
        };
      },
      initialize: function() {
        var houseColor, posStr, startColor;
        posStr = this.getPosStr();
        startColor = getStartColor(posStr);
        houseColor = getHouseColor(posStr);
        if (Barricade.exit === posStr) {
          return this.set('type', 'exit');
        } else if (startColor) {
          this.set('type', 'start');
          return this.set('color', startColor);
        } else if (houseColor) {
          this.set('type', 'house');
          return this.set('color', houseColor);
        }
      },
      reset: function() {
        return this.set({
          hoverable: false,
          pawn: void 0,
          source: void 0,
          target: void 0
        });
      },
      isExit: function() {
        return 'exit' === this.get('type');
      },
      isHouse: function() {
        return 'house' === this.get('type');
      },
      isEmpty: function() {
        return (!this.get('pawn')) && !this.isHouse();
      },
      isBarricade: function() {
        return 'barricade' === this.get('pawn');
      },
      getPosStr: function() {
        return posObjectToStr(this.get('pos'));
      }
    });
    CellModel.getStart = getStart;
    CellModel.posStrToObject = posStrToObject;
    return CellModel;
  });

}).call(this);
