###
  chat.coffee
###

define ->
  initialize = (username) ->
    socket = io.connect 'http://localhost'
    socket.on 'new message', (userMessage) ->
      ($ '#conversation').prepend '<b>' + userMessage.username + ' : </b>' + userMessage.message + '<br/>'
  
    ($ '#new_message').keypress (e) ->
        if(e.which is 13)
          message = ($ '#new_message').val()
          ($ '#new_message').val('')
          socket.emit 'send message', message
    
    socket.emit 'new user', username
    
  initialize: initialize    