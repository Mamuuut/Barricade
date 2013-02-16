###
  chat.coffee
###

define ->
  initialize = (socket, username) ->
    socket.on 'new message', (userMessage) ->
      newMessage = $( '<span>' +
        '<b>' + userMessage.username + ' : </b>' + userMessage.message + '<br/>' +
        '</span>' )
      ($ '#conversation').prepend newMessage
      setTimeout ->
        newMessage.addClass 'visible', 0
  
    ($ '#new_message').keypress (e) ->
        if(e.which is 13)
          message = ($ '#new_message').val()
          ($ '#new_message').val('')
          socket.emit 'send message', message
    
  initialize: initialize    
