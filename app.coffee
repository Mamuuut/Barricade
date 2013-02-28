###
  app.coffee
###

### require modules ###
express   = require 'express'
http      = require 'http'
flash     = require 'connect-flash'
passport  = require 'passport'
espresso  = require './espresso.coffee'
DB        = require './accessDB'
sockets   = require './sockets'
routes    = require './routes'
errors    = require './routes/errors'

### create express server ###
app = express()
server = http.createServer app

### parse args (- coffee and the filename) ###
ARGV = process.argv[2..]
rargs = /-{1,2}\w+/
rprod = /-{1,2}(p|production)/
  
for s in ARGV
  m = rargs.exec s
  app.set('env', 'production') if m and m[0] and m[0].match rprod

### express configuration ###
app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.static __dirname + '/public'
  app.use express.session { secret: 'mamut game' }
  app.use flash()
  
  app.use passport.initialize()
  app.use passport.session()

  ### app routes ###
  new routes app
  
  app.use errors.errorLogger
  app.use errors.errorHandler
  app.use errors.notFoundHandler

### watch coffeescript sources ###
coffee = espresso.core.exec espresso.core.node_modules_path + 'coffee -o public/js -w -c public/coffee'
coffee.stdout.on 'data', (data) ->
  #console.log data
  espresso.core.minify() if app.env == 'production'

### watch stylus sources ###
espresso.core.exec espresso.core.node_modules_path + 'stylus -w -c styl/styles.styl -o public/css/'

### io configuration ###
io = (require 'socket.io').listen server
app.configure 'development', ->
  io.set 'log level', 1

app.configure 'production', ->
  io.enable 'browser client minification'
  io.enable 'browser client etag'
  io.enable 'browser client gzip'
  io.set 'log level', 1
  
new sockets.connect io

### DB access ###
app.configure 'development', ->
  app.set 'db uri', 'mongodb://localhost/db'

app.configure 'production', ->
  app.set 'db uri', 'mongodb://mamut:cimeurz@ds029807.mongolab.com:29807/barricade'
  
db = new DB.startup app.get('db uri')

### start server ###
port = process.env.OPENSHIFT_INTERNAL_PORT || 3000
console.log 'port', port

server.listen port, ->
  console.log "Server listening on port %d", port
  
module.exports = app