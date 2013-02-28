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
  app.env = 'production' if m and m[0] and m[0].match rprod

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

### DB access ###
conn = 'mongodb://localhost/db'
db = new DB.startup conn

### io configuration ###
io = (require 'socket.io').listen server
io.set 'log level', 1
new sockets.connect io

### start server ###
server.listen 3000, ->
  espresso.core.logEspresso()
  console.log "Server listening on port %d", 3000
  
module.exports = app