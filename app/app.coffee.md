#Wolop - Global Content Management System

##CoffeeScript/JavaScript Note: 

This code file is written in CoffeeScript.  If you find it easier to read this code in JavaScript, you can use [this CoffeeScript to JavaScript converter](http://js2coffee.org/) to automatically convert to and from CoffeeScript to JavaScript.

##Jade/HTML Node:

Other parts of this project use Jade instead of HTML.  Here is a [Jade to HTML converter](http://html2jade.org/) if you need some clarification what a template is doing.

##Config (/app/config.coffee.md)

We start by setting the environment variable that will select the type of configuraton we need from /app/config.coffee.md.
    
	env = 'development'

	config = require('./config')[env]
	console.log 'Sunshine server configured for ' + env + ', listening on port ' + config.port

##Import required Node.js packages 

These are all [npm packages](https://www.npmjs.org/) that have descriptions in the [npm registry](https://www.npmjs.org/).

You can search NPM by [Googling](http://google.com/) any of these required items as 'npm [required item]'.  You can also search the NPM registry from the command line with 'npm search [required item]'.  So we will not document each required item here.

	debug = require('debug') 'wolop'
	express = require 'express'
	path = require 'path'
	favicon = require 'serve-favicon'
	logger = require 'morgan'
	cookieParser = require 'cookie-parser'
	bodyParser = require 'body-parser'
	compression = require 'compression'
	coffeescript = require 'connect-coffee-script'
	stylus = require 'stylus'
	nib = require 'nib'
	crypto = require 'crypto'
	mongoose = require 'mongoose'
	Hashids = require 'hashids'
	ids = new Hashids config.hashidSalt

#App Creation

Here we create the [Express.js](http://expressjs.com/) application (called 'app'), we then pass the app as an argument to invoke the Server method of the Node.js 'http' module.  This creates the webserver.

	app = express()
	http = require('http').Server app

##App settings

We defined a couple of variables that we can use throughout the application.

	app.set 'env', env
	app.set 'port', config.port

#View Engines

##JADE

Here is where we tell the application where to find our view files and to use [Jade as the templating engine](http://jade-lang.com/)

	app.set 'views', path.join(__dirname, 'views')
	app.set 'view engine', 'jade'

##Other options

####EJS

[EJS](http://www.embeddedjs.com/) uses a syntax most similar to PHP or ASP, using tags in the HTML to delimit where JavaScript code should be processed and echoed out to the page.  This option is not currently installed, but could be if we found a need for it.

####Handlebars & Mustache

[Handlebars](http://handlebarsjs.com/) & [Mustache](http://mustache.github.io/) are related template frameworks that use curly braces to delimit where code should be placed in a web template.  This is not currently installed on this server, but could be, and is commonly used in many Node.js frameworks.

#Middleware

Middleware is a [core concept](http://stephensugden.com/middleware_guide/) of an Express.js server.  It's part of the [Connect.js](https://github.com/senchalabs/connect) framework that underlies the Express.js application.  It's what gives us the functionality to handle different parts of a request in discrete steps.

##using Middleware

Everything in Express.js that isn't specific to being a web server is handled with these Connect middlewares.  That includes things like supporting favicons, logging, compression, and the actual parsing of the body of the http request and the cookies contained in the headers.

We add these middlewares through this list of calls to 'app.use'.

	app.use favicon(__dirname + '/public/favicon.ico')
	app.use logger('dev')
	app.use compression()
	app.use bodyParser.json()
	app.use bodyParser.urlencoded(extended: false)
	app.use cookieParser()

##Stylus and nib

[nib](http://tj.github.io/nib/) is a CSS3 middleware that will look at our [Stylus](http://learnboost.github.io/stylus/) code and automaticlly insert vendor specific CSS3 rules.  For example, if we define a CSS rule that is 'border-radius 10px', nib will automatically insert the '-webkit-border-radius 10px', '-moz-border-radius 10px'.... '-o-border-radius 10px'.

Enabling nib is a little tricky.  It requires this custom Stylus compilaton code:

	app.use stylus.middleware(
		src: path.join __dirname, 'public'
		compile: (str, path) ->
			stylus(str)
				.set('filename', path)
				.set('compress', false)
				.use nib()
	)

##CoffeeScript

Here we enable the application to use [CoffeeScript](http://coffeescript.org/) for client-side code.  CoffeeScript files will be stored in the './app/coffee' directory, which is above the public scope of the client-side javascript files.
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

Routes are used to define requests for specific pages of content.

All requests to the root domain (as indicated by the path '/' below) will be handled by routes defined in the routes package.  This package can be found in './app/routes/index.coffee'.
    
	routes = require './routes/index'
	app.use '/', routes

##Angular.js Partials

Partials are HTML snippets that will be used to build [Angular.js](https://angularjs.org/) components.  There is no Angular.js code in the server side of this application.  But we have to define the partials folder and its routing rules, which we've done in the file './app/routes/partials.coffee' so that our web server will send us this snippets when requested.

	partials = require './routes/partials'
	app.use '/partials', partials

#404's

Here, we catch 404s and forward them to an error handler

	app.use (req, res, next) ->
		err = new Error('Not Found')
		err.status = 404
		next err

##Mongoose (MongoDB ORM)

for now these are commented out.  But they are some inline examples of using [Mongoose](http://mongoosejs.com/) to define [MongoDB](http://www.mongodb.org/) schemas.

	mongoose.connect 'mongodb://localhost:27017/wolop'

	Admin = mongoose.model('Admin',
		firstName: String
		lastName: String
		email: {type: String, unique: true}
		username: {type: String, unique: true}
		password: String
	)
	Website = mongoose.model('Website',
		name: String
		slug: {type: String, unique: true}
		domain: String
	)
	ContentGroup = mongoose.model('ContentGroup',
		name: {type: String, unique: true}
		slug: {type: String, unique: true}
    )
	Page = mongoose.model('Page',
		name: String
		slug: {type: String, unique: true}
	)
	Menu = mongoose.model('Menu',
		name: String
	)

##Socket.io (web socket server)

[Socket.io](http://socket.io/) is the socket server that maintains a 2-way communication socket between the client and the server for real-time communications.  The client does not have to request data for the server to push updates to the client.

We invoke Socket.io by passing the http server instance into its root method call.

	io = require('socket.io') http

This is the Socket.io connection event handler.  It lets us know when a user is connected or disconnected from the applicaton via the web socket.

	io.on 'connection', (socket) ->
		domain = socket.handshake.headers.host.split(':')[0]
		ip = socket.client.conn.remoteAddress
		console.log '+ user connected + domain: ' + domain + ' IP: ' + ip
		socket.on 'disconnect', ->
			console.log '- user disconnected -'
		socket.on 'user-login', (data) ->
			if data
				Admin.findOne({username: data.username, password: data.password}, (err, data) ->
					if data
						data.password = '***************'
						socket.emit 'login-success', data
				)
		socket.on 'create-user', (data) ->
			if data && data.email
				console.log data
				Admin.findOneAndUpdate(
					{email: data.email}
					{$set: data}
					{upsert: true}
				).exec()
			
##Error Handlers

If we are running the appliation in a 'development' environment, then we add the error handler that will print stacktrace

	if app.get('env') is 'development'
		app.use (err, req, res, next) ->
			res.status err.status or 500
			res.render 'error',
				message: err.message
				error: err

This is the production error handler used so that no stacktraces are leaked to user.

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