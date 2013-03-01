({
    baseUrl: 'js',
    name: "main",
    out: "js/main.js",
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
	    jquery:       'libs/jquery-1.9.1.min',
	    underscore:   'libs/underscore-min',
	    backbone:     'libs/backbone-min',
	    GameModel:    'models/game',
	    CellModel:    'models/cell',
	    GameList:     'collections/games',
	    CellGrid:     'collections/cells',
	    GameLineView: 'views/gameline',
	    GameListView: 'views/gamelist',
	    BoardView:    'views/board',
	    CellView:     'views/cell',
	    MainView:     'views/main',
	    ChatView:     'views/chat'
	}
})
