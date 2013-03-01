config = 
  production:
    server: 
      ip  : process.env.OPENSHIFT_INTERNAL_IP
      port: process.env.OPENSHIFT_INTERNAL_PORT || 3000
    mongodb: (->
      username = process.env.MONGO_USER
      password = process.env.MONGO_PASS
      'mongodb://' + username + ':' + password + '@ds029807.mongolab.com:29807/barricade')() 
  
  development:
    server: 
      ip  : undefined
      port: 3000
    mongodb: 'mongodb://localhost/db'

module.exports = 
  initialize: (app) ->
    app.configure 'development', ->
      app.set 'config', config.development
    
    app.configure 'production', ->
      app.set 'config', config.production
      
    
