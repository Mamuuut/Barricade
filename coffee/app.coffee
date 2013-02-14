###
  app.coffee
###

define ['chat', 'collections/games', 'views/games'], (Chat, GameList, GamesView) ->
    initialize = ->
      
      gameList = new GameList
          
      $.get '/user', (data) ->
        Chat.initialize data.username
        
        gamesView = new GamesView { games: gameList, playerid: data.userid }
        gameList.fetch 
          success: (games) ->
            console.log games
      
    initialize: initialize
