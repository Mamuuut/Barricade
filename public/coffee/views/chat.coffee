
define [ 'backbone' ], (Backbone) ->
  ChatView = Backbone.View.extend
    el: $("#chat"),  
    chatSocket: null,
    
    template: _.template($('#chat-template').html()),
     
    initialize: ->
      @chatSocket = io.connect '/chat'
      
      ###
        @chatSocket.on 'connect', => 
          @chatSocket.emit 'new user', @options.user
      ###
        
      @chatSocket.on 'new message', (userMessage) =>
        newMessage = $ @template(userMessage)
        @$('#conversation').prepend newMessage
        setTimeout ->
          newMessage.addClass 'visible', 0

    events: 
      "click .switch":  "switchSize",
      "keypress #new_message": "keyPressed"
    
    render: -> {}
    
    play: (game) -> {}
    
    switchSize: ->
      @$el.toggleClass 'minimized'
      
    keyPressed: (e) ->
      if(e.which is 13)
        message = @$('#new_message').val()
        @$('#new_message').val ''
        @chatSocket.emit 'send message', message
   
  ChatView