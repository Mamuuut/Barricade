###
  chat.coffee
###

define ->
  initialize = (user) ->
    chatSocket = io.connect '/chat'
    chatSocket.on 'connect', -> 
      chatSocket.emit 'new user', user
    
    # New message listener
    chatSocket.on 'new message', (userMessage) ->
      newMessage = $( '<span>' +
        '<b>' + userMessage.username + ' : </b>' + userMessage.message + '<br/>' +
        '</span>' )
      ($ '#conversation').prepend newMessage
      setTimeout ->
        newMessage.addClass 'visible', 0
      
    # Chat input
    ($ '#new_message').keypress (e) ->
        if(e.which is 13)
          message = ($ '#new_message').val()
          ($ '#new_message').val('')
          chatSocket.emit 'send message', message
    
    
  initialize: initialize    
