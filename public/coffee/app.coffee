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
          chatView = new ChatView
            user: user
            socket: socket
          
          # Game List
          gameListView = new GameListView
            games: gameList
            player: user
            socket: socket
            
          gameList.fetch()
          
          # Board
          boardView = new BoardView
            playerid: user.id
            socket: socket
        
          # Main View
          mainView = new MainView 
            user: user
            socket: socket
            gameListView: gameListView,
            boardView: boardView,
            chatView: chatView
      
    initialize: initialize
