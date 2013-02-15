requirejs.config({
  shim: {
    backbone: {
      deps: [ "underscore", "jquery" ],
      exports: "Backbone"
    },
    underscore: {
	  exports: "_"
  	}
  },
  
  paths: {
    'mocha'        		: '../../js/libs/mocha',
    'chai'             	: '../../js/libs/chai',
    'jquery'           	: '../../js/libs/jquery-1.9.1.min',
    'underscore'       	: '../../js/libs/underscore-min',
    'backbone'         	: '../../js/libs/backbone-min',
    'GameModel'        	: '../../js/models/game',
    'GameList'         	: '../../js/collections/games',
    
    // ============ Specs follow ============
    'GameModelSpec'  	: 'models/game.spec',
	'GameListSpec'  	: 'collections/games.spec'
  }
});

require(['require', 'jquery', 'chai', 'mocha'], function(require, $, chai) {
  chai.should();
  window.expect = chai.expect;
  window.assert = chai.assert;
  
  mocha.setup({ ui: 'bdd' });
  require(['GameModelSpec', 'GameListSpec'], function() {
    mocha.run();
  });
});