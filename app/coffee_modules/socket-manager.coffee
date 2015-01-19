_und = require 'underscore'
models = require '../coffee_modules/models'
db = require '../coffee_modules/data-api'
authenticatedUsers = {}

websites = []
contentGroups = []
locales = []
menus = []
pages = []
users = []

db.getWebsites (data) -> websites = data
db.getContentGroups (data) -> contentGroups = data
db.getLocales (data) -> locales = data
db.getMenus (data) -> menus = data
db.getPages (data) -> pages = data
db.getAdmins (data) -> users = data

module.exports = (io) ->

	io.on 'connection', (socket) ->

		socket.join 'all-users'

		domain = socket.handshake.headers.host.split(':')[0]
		ip = socket.client.conn.remoteAddress

		console.log '+ user ' + socket.id + ' connected + domain: ' + domain + ' IP: ' + ip

		socket.on 'disconnect', ->
			authenticatedUsers[socket.id] = undefined
			io.to('auth-users').emit 'auth-users-update', authenticatedUsers
			console.log '- user ' + socket.id + ' disconnected - ' + domain + ' IP: ' + ip

		socket.on 'create-user', (data) ->
			db.upsertAdmin data, ->
				db.getAdmins (data) ->
					users = data
					io.to('auth-users').emit 'users-update', data

		socket.on 'create-content-group', (data) ->
			db.upsertContentGroup data, ->
				db.getContentGroups (data) ->
					contentGroups = data
					io.to('auth-users').emit 'content-groups-update', data

		socket.on 'create-locale', (data) ->
			db.upsertLocale data, ->
				db.getLocales (data) ->
					locales = data
					io.to('auth-users').emit 'locales-update', data

		socket.on 'create-menu', (data) ->
			db.upsertMenu data, ->
				db.getMenus (data) -> 
					menus = data
					io.to('auth-users').emit 'menus-update', data

		socket.on 'create-page', (data) ->
			db.upsertPage data, ->
				db.getPages (data) -> 
					pages = data
					io.to('auth-users').emit 'pages-update', data

		socket.on 'create-website', (data) ->
			db.upsertWebsite data, ->
				db.getWebsites (data) -> 
					websites = data
					io.to('auth-users').emit 'websites-update', data

		socket.on 'user-login', (data) ->
			if data
				models.Admin.findOne({username: data.username, password: data.password}, (err, data) ->
					if data
						socket.join 'auth-users'
						data.password = data.username = data.email = data.__v = undefined
						data.socket = socket.id
						socket.emit 'login-success', data
						authenticatedUsers[socket.id] = data
						io.to('auth-users').emit 'auth-users-update', authenticatedUsers
						socket.emit 'websites-update', websites
						socket.emit 'content-groups-update', contentGroups
						socket.emit 'locales-update', locales
						socket.emit 'menus-update', menus
						socket.emit 'pages-update', pages
						socket.emit 'users-update', users
				)
