define( ['GameModel'], function(GameModel) {
	describe('GameModel', function() {
        var gameModel;
		
		describe('Default', function() {
			gameModel = new GameModel();
			
			it('is defined', function() {
			    gameModel.should.exist;
		    });
		    
			it('should have a default date', function() {
        		gameModel.get('date').should.exist;
		    });
		    
			it('should have a default player', function() {
        		gameModel.get('currentplayer').should.exist.equal(0);
		    });
		    
			it('should have a default players array', function() {
				expect(gameModel.get('players')).to.be.an('array');
		    });
		    
			it('should have a default cells array', function() {
				expect(gameModel.get('cells')).to.be.an('array');
		    });
		});
	});
});