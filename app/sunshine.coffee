port = process.env.PORT || 3000

debug = require('debug') 'wolop'
express = require 'express'
path = require 'path'
favicon = require 'serve-favicon'
logger = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
compression = require 'compression'
routes = require './routes/index'
partials = require './routes/partials'
coffeescript = require 'connect-coffee-script'
app = express()
http = require('http').Server app
io = require('socket.io') http
stylus = require 'stylus'
nib = require 'nib'
crypto = require 'crypto'
mongoose = require 'mongoose'
Hashids = require 'hashids'
ids = new Hashids 'f699abd2b2cae56e3bfe81154e29ed47'
"""
mongoose.connect 'mongodb://localhost:42047/wolop'

Admin = mongoose.model('Admin',
    username: {type: String, unique: true}
    password: String
    name: String
)
User = mongoose.model('User',
    username: {type: String, unique: true}
    password: String
    name: String
)
""" 
io.on 'connection', (socket) ->
    #domain = socket.handshake.headers.host.split(':')[0]
    #ip = socket.client.conn.remoteAddress
    console.log '+ user connected +'
    socket.on 'disconnect', ->
        console.log '- user disconnected -'
        

app.set 'env', 'development'
app.set 'port', port

# view engine setup
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.use favicon(__dirname + '/public/favicon.ico')
app.use logger('dev')
app.use compression()
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()

"""
Custom Stylus Compile to enable 'nib'
"""
stylusCustomCompile = (str, path) ->
    stylus(str)
        .set('filename', path)
        .set('compress', false)
        .use nib()
app.use stylus.middleware(
    src: path.join __dirname, 'public'
    compile: stylusCustomCompile
)
"""
/nib
"""
app.use coffeescript 
    src: __dirname + '/coffee'
    dest: __dirname + '/public/javascripts'
    prefix: '/javascripts'
app.use express.static(path.join(__dirname, 'public'))
app.use '/', routes
app.use '/partials', partials

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next err

# error handlers

# development error handler
# will print stacktrace
if app.get('env') is 'development'
    app.use (err, req, res, next) ->
        res.status err.status or 500
        res.render 'error',
            message: err.message
            error: err

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
        message: err.message
        error: {}

server = http.listen app.get('port'), ->
    debug 'Sunshine server listening on port ' + server.address().port
    
module.exports = 
    app: app
    server: server
    io: io