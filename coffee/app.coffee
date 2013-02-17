###
  app.coffee
###

define ['ChatView', 'GameList', 'GameListView', 'BoardView', 'MainView'], (ChatView, GameList, GameListView, BoardView, MainView) ->
    initialize = ->
      
      gameList = new GameList
          
      $.get '/user', (user) ->
        chatView = new ChatView { user: user }
        
        gameListView = new GameListView { games: gameList, playerid: user.id }
        gameList.fetch()
        
        boardView = new BoardView { playerid: user.id }
      
        mainView = new MainView 
          gameListView: gameListView,
          boardView: boardView
      
    initialize: initialize
