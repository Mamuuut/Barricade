define('GameModelSpec', ['GameModel'], function(GameModel) {
	describe('GameModel', function() {
        var gameModel;
		
		describe('Default', function() {
			gameModel = new GameModel;
			
			it('is defined', function() {
			      return gameModel.should.exist;
		    });
		    
			it('should have a default date', function() {
        		return gameModel.get('date').should.exist;
		    });
		});
	});
});