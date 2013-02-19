// Generated by CoffeeScript 1.3.3

/*
  game_model.coffee
*/


(function() {

  define(['underscore', 'backbone'], function(_, Backbone) {
    var CellModel, EXIT, HOUSES, PAWNS, START, TYPES, getHouseColor, getStart, getStartColor, posObjectToStr, posStrToObject;
    TYPES = ['normal', 'exit', 'start', 'house'];
    PAWNS = ['red', 'green', 'yellow', 'blue', 'barricade'];
    EXIT = "8:0";
    START = {
      red: "2:13",
      green: "6:13",
      yellow: "10:13",
      blue: "14:13"
    };
    HOUSES = {
      red: ["1:14", "2:14", "3:14", "1:15", "2:15", "3:15", "1:16", "3:16"],
      green: ["5:14", "6:14", "7:14", "5:15", "6:15", "7:15", "5:16", "7:16"],
      yellow: ["9:14", "10:14", "11:14", "9:15", "10:15", "11:15", "9:16", "11:16"],
      blue: ["13:14", "14:14", "15:14", "13:15", "14:15", "15:15", "13:16", "15:16"]
    };
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
      return START[color];
    };
    getStartColor = function(posStr) {
      var color;
      color = void 0;
      _.each(START, function(startPosStr, startColor) {
        if (startPosStr === posStr) {
          return color = startColor;
        }
      });
      return color;
    };
    getHouseColor = function(posStr) {
      var color;
      color = void 0;
      _.each(HOUSES, function(houses, houseColor) {
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
          hoverable: false,
          selected: false,
          targeted: false,
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
        if (EXIT === posStr) {
          return this.set('type', 'exit');
        } else if (startColor) {
          this.set('type', 'start');
          return this.set('color', startColor);
        } else if (houseColor) {
          this.set('type', 'house');
          return this.set('color', houseColor);
        }
      },
      isHouse: function() {
        return 'house' === this.get('type');
      },
      isBarricade: function() {
        return 'barricade' === this.get('pawn');
      },
      getPosStr: function() {
        return posObjectToStr(this.get('pos'));
      }
    });
    CellModel.HOUSES = HOUSES;
    CellModel.PAWNS = PAWNS;
    CellModel.getStart = getStart;
    CellModel.posStrToObject = posStrToObject;
    return CellModel;
  });

}).call(this);
