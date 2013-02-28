
define [ 'backbone' ], (Backbone) ->
  ChatView = Backbone.View.extend
    el: $("#chat"),  
    chatSocket: null,
    
    template: _.template($('#chat-template').html()),
     
    initialize: ->
      @socket = io.connect()
        
      @socket.on 'new message', (userMessage) =>
        newMessage = $ @template(userMessage)
        @$('#conversation').prepend newMessage
        setTimeout ->
          newMessage.addClass 'visible', 0

    events: 
      "click .header":  "switchSize",
      "keypress #new_message": "keyPressed"
    
    switchSize: ->
      @$el.toggleClass 'minimized'
    
    minimize: ->
      @$el.addClass 'minimized'
    
    maximize: ->
      @$el.removeClass 'minimized'
    
    keyPressed: (e) ->
      if(e.which is 13)
        message = @$('#new_message').val()
        @$('#new_message').val ''
        @socket.emit 'send message', message
   
  ChatView