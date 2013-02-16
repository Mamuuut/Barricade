###
  app.coffee
###

define ['chat', 'GameList', 'GameListView'], (Chat, GameList, GameListView) ->
    initialize = ->
      
      gameList = new GameList
          
      $.get '/user', (user) ->
        Chat.initialize user
        
        gameListView = new GameListView { games: gameList, playerid: user.id }
        gameList.fetch()
      
    initialize: initialize
