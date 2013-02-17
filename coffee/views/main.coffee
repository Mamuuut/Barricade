
define [ 'backbone' ], (Backbone) ->
  MainView = Backbone.View.extend
    el: $('body'),  
     
    initialize: ->
      @playerid = @options.playerid
        
      @gameListView = @options.gameListView
      @boardView = @options.boardView
      
      @gameListView.on 'play', (game) =>
        @$('.content').addClass 'playing'
        @boardView.play game

      @boardView.on 'back', =>
        @$('.content').removeClass 'playing'

    events: {}
    
    render: -> {}
   
  MainView