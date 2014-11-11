#Wolop - a SatoriSunshine server
##Port (defaults to 3000)
Just to make it easy t set the port, we start by setting the value at the top of our code file.  This will probably be moved into ./app/config.coffee.md in an upcomming commit.

    port = process.env.PORT || 3000

##Import required Node.js packages 
These are all npm packages that have descriptions in the npm registry.
You can search NPM by Googling any of these required items as 'npm <required item>'.  You can also search the NPM registry from the command line with 'npm search <required item>'.  So we will not document each required item here.

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

##App settings
We defined a couple of variables that we can use throughout the application.

    app.set 'env', 'development'
    app.set 'port', port

#View Engine
##JADE
Here is where we tell the application where to find our view files and to use Jade as the templating engine

    app.set 'views', path.join(__dirname, 'views')
    app.set 'view engine', 'jade'

#Middleware
Middleware is a core concept of an Express.js server.  It's part of the Connect.js framework that underlies the Express.js application.  It's what gives us the functionality to handle different parts of a request in discrete steps.
##favicon
Everything in Express.js that isn't specific to being a web server is handled with middlewares.  That includes things like supporting favicons, logging, compression, and the actual parsing of the body of the http request and the cookies contained in the headers.
We add these middlewares through this list of calls to 'app.use'.

    app.use favicon(__dirname + '/public/favicon.ico')
    app.use logger('dev')
    app.use compression()
    app.use bodyParser.json()
    app.use bodyParser.urlencoded(extended: false)
    app.use cookieParser()

##Stylus and nib
'nib' is a CSS3 middleware that will look at our Stylus code and automaticlly insert vendor specific CSS3 rules.  For example, if we define a CSS rule that is 'border-radius 10px', nib will automatically insert the '-webkit-border-radius 10px', '-moz-border-radius 10px'.... '-o-border-radius 10px'.
Enabling nib is a little tricky.  It requires this custom Stylus compilaton code:

    stylusCustomCompile = (str, path) ->
        stylus(str)
            .set('filename', path)
            .set('compress', false)
            .use nib()
    app.use stylus.middleware(
        src: path.join __dirname, 'public'
        compile: stylusCustomCompile
    )

##CoffeeScript
Here we enable the application to use CoffeeScript for client-side code.  CoffeeScript files will be stored in the './app/coffee' directory, which is above the public scope of the client-side javascript files.
This web server will automatically look in this coffee directory when requests are made for javascript files located in './app/public/javascripts/'.  If the CoffeeScript file of the same name exists in this directory, it will be compiled into a JavaScript file, cached in the javascripts directory, and served to the user.
####Does it compile the CoffeeScript on every single request?
No.  If the JavaScript file in the cache is newer than the CoffeeScript source file, then the cached version of the JavaScript file is set to the user instantly.

    app.use coffeescript 
        src: __dirname + '/coffee'
        dest: __dirname + '/public/javascripts'
        prefix: '/javascripts'

##Serving Static Files
Static files, like images, PDFs, etc. need to be served out of a specific folder that doesn't include the rest of the source code for this web application.  So we use the built in 'express.static' middleware to tell the server to send any files that exist in this directory to the user without any further processing.

    app.use express.static(path.join(__dirname, 'public'))

#Routes
Routes are used to define requests for specific pages of content.  We imported two route packages at the top of this file, called 'routes' and 'partials'.
All requests to the root domain (as indicated by the path '/' below) will be handled by routes defined in the routes package.  This package can be found in './app/routes/index.js'.

    app.use '/', routes

##Angular.js Partials
Partials are HTML snippets that will be used to build Angular.js components.  There is no Angular.js code in the server side of this application.  But we have to define the partials folder and its routing rules, which we've done in the file './app/routes/partials.js'.

    app.use '/partials', partials

#404's
Here, we catch 404s and forward them to an error handler

    app.use (req, res, next) ->
        err = new Error('Not Found')
        err.status = 404
        next err

##Mongoose (MongoDB ORM)
for now these are commented out.  But they are some inline examples of using Mongoose to define MongoDB schemas.

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

##Socket.io (web socket server)
for now, this is just a basic Socket.io connection event handler, that echos out that us user connected, and shows how to register additional listeners for when a user disconnects.
    io.on 'connection', (socket) ->
        #domain = socket.handshake.headers.host.split(':')[0]
        #ip = socket.client.conn.remoteAddress
        console.log '+ user connected +'
        socket.on 'disconnect', ->
            console.log '- user disconnected -'
            

##Error Handlers
If we are in a 'development' environment, then we add the error handler that will print stacktrace

    if app.get('env') is 'development'
        app.use (err, req, res, next) ->
            res.status err.status or 500
            res.render 'error',
                message: err.message
                error: err

production error handler no stacktraces leaked to user

    app.use (err, req, res, next) ->
        res.status err.status or 500
        res.render 'error',
            message: err.message
            error: {}

#Server startup
Here is where we actually invoke the server to listen on a particular port and respond to requests.

    server = http.listen app.get('port'), ->
        debug 'Sunshine server listening on port ' + server.address().port

#Module.exports
This is the final step in bootstrapping the server.  At this point, the server should be fully functional and all that's left to do is export the component parts of the sunshine server.
        
    module.exports = 
        app: app
        server: server
        io: io