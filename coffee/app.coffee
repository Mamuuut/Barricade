###
  app.coffee
###

define ['chat', 'GameList', 'GameListView'], (Chat, GameList, GameListView) ->
    initialize = ->
      
      gameList = new GameList
          
      $.get '/user', (data) ->
        Chat.initialize data.username
        
        gameListView = new GameListView { games: gameList, playerid: data.userid }
        gameList.fetch 
          success: (games) ->
            console.log games
            gameListView.render()
      
    initialize: initialize
