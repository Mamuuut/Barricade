requirejs.config({
  paths: {
    'mocha'            : '../../js/libs/mocha',
    'chai'             : '../../js/libs/chai',
    'jquery'           : '../../js/libs/require-jquery',
    'underscore'       : '../../js/libs/underscore-min',
    'backbone'         : '../../js/libs/backbone-min',
    'GameModel'        : '../../js/models/game',
    
    // ============ Specs follow ============
    'GameModelSpec'  : 'models/game.spec'
  }
});

require(['require', 'jquery', 'chai', 'mocha'], function(require, $, chai) {
  chai.should();
  window.expect = chai.expect;
  window.assert = chai.assert;
  
  mocha.setup({ ui: 'bdd' });
  require(['GameModelSpec'], function() {
    mocha.run();
  });
});