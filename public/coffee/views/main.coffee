
define [ 'backbone' ], (Backbone) ->
  MainView = Backbone.View.extend
    el: $('body'),  
     
    initialize: ->
      @socket = @options.socket
        
      @gameListView = @options.gameListView
      @boardView = @options.boardView
      @chatView = @options.chatView
      
      @gameListView.on 'play', (game) =>
        @$('.content').find('div').addClass 'playing'
        @boardView.play game
        @chatView.minimize()

      @boardView.on 'back', =>
        @$('.content').find('div').removeClass 'playing'
        @chatView.maximize()
        
      @socket.on 'update victories', (nbVictories) => 
        $.get '/user', (user) =>
          @updateVictories user.victories
      
      @updateVictories @options.user.victories
    
    updateVictories: (nbVictories) -> 
      @$('#nb-victory').html(nbVictories)
      
  MainView