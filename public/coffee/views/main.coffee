
define [ 'backbone' ], (Backbone) ->
  MainView = Backbone.View.extend
    el: $('body'),  
     
    initialize: ->
      @playerid = @options.playerid
        
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

    events: {}
    
    render: -> {}
   
  MainView