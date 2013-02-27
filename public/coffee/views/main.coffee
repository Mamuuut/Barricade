
define [ 'backbone' ], (Backbone) ->
  MainView = Backbone.View.extend
    el: $('body'),  
     
    initialize: ->
      @playerid = @options.playerid
        
      @gameListView = @options.gameListView
      @boardView = @options.boardView
      
      @gameListView.on 'play', (game) =>
        @$('.content').find('div').addClass 'playing'
        @boardView.play game

      @boardView.on 'back', =>
        @$('.content').find('div').removeClass 'playing'

    events: {}
    
    render: -> {}
   
  MainView