// Generated by CoffeeScript 1.5.0
(function() {
  var Barricade;

  Barricade = {
    types: ['normal', 'exit', 'start', 'house'],
    pawns: ['red', 'green', 'yellow', 'blue', 'barricade'],
    colors: ['red', 'green', 'yellow', 'blue'],
    status: ['waiting_player', 'playing', 'complete'],
    exit: "8:0",
    start: {
      red: "2:13",
      green: "6:13",
      yellow: "10:13",
      blue: "14:13"
    },
    houses: {
      red: ["1:14", "2:14", "3:14", "1:15", "2:15", "3:15", "1:16", "3:16"],
      green: ["5:14", "6:14", "7:14", "5:15", "6:15", "7:15", "5:16", "7:16"],
      yellow: ["9:14", "10:14", "11:14", "9:15", "10:15", "11:15", "9:16", "11:16"],
      blue: ["13:14", "14:14", "15:14", "13:15", "14:15", "15:15", "13:16", "15:16"]
    },
    barricades: ["8:1", "8:3", "8:4", "8:5", "6:7", "10:7", "0:11", "4:11", "8:11", "12:11", "16:11"],
    minPlayers: 2,
    maxPlayers: 4,
    cells: [[8], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], [0, 16], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], [8], [6, 7, 8, 9, 10], [6, 10], [4, 5, 6, 7, 8, 9, 10, 11, 12], [4, 12], [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], [2, 6, 10, 14], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], [0, 4, 8, 12, 16], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], [1, 2, 3, 5, 6, 7, 9, 10, 11, 13, 14, 15], [1, 2, 3, 5, 6, 7, 9, 10, 11, 13, 14, 15], [1, 3, 5, 7, 9, 11, 13, 15]]
  };

  if (typeof exports === 'undefined') {
    define(function() {
      return Barricade;
    });
  } else {
    module.exports = Barricade;
  }

}).call(this);
