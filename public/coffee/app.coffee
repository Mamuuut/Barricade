###
  app.coffee
###

define ['ChatView', 'GameList', 'GameListView', 'BoardView', 'MainView'], (ChatView, GameList, GameListView, BoardView, MainView) ->
    initialize = ->
      
      gameList = new GameList
          
      $.get '/user', (user) ->
        
        socket = io.connect()
        socket.on 'connect', => 
          socket.emit 'new user', user
        
          # Chat
          chatView = new ChatView { user: user }
          
          # Game List
          gameListView = new GameListView { games: gameList, playerid: user.id }
          gameList.fetch()
          
          # Board
          boardView = new BoardView { playerid: user.id }
        
          # Main View
          mainView = new MainView 
            gameListView: gameListView,
            boardView: boardView
      
    initialize: initialize
