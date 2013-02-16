###
  app.coffee
###

define ['chat', 'GameList', 'GameListView'], (Chat, GameList, GameListView) ->
    initialize = ->
      
      gameList = new GameList
          
      $.get '/user', (data) ->
        socket = io.connect()
        socket.emit 'new user', 
          name: data.username,
          id: data.userid
        
        Chat.initialize socket, data.username
        
        gameListView = new GameListView { games: gameList, playerid: data.userid, socket: socket }
        gameList.fetch()
      
    initialize: initialize
