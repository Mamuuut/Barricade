define( ['GameList'], function(GameList) {
	describe('GameList', function() {
        var gameList;
			
		describe('New list', function() {
			gameList = new GameList();
			
			it('is defined', function() {
			    gameList.should.exist;
		    });
		});
	});
});