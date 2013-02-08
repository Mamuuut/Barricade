###
  app.coffee
###

define ['chat'], ( Chat ) ->
    initialize = ->
      $.get '/username', (data) ->
        console.log 'username', data
        Chat.initialize data.username
      
    initialize: initialize
