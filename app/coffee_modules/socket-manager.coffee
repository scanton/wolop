_und = require 'underscore'
models = require '../coffee_modules/models'
db = require '../coffee_modules/data-api'
authenticatedUsers = {}

websites = {}
contentGroups = {}
locales = {}
menus = {}
pages = {}

module.exports = (io) ->

	io.on 'connection', (socket) ->

		socket.join 'all-users'

		domain = socket.handshake.headers.host.split(':')[0]
		ip = socket.client.conn.remoteAddress

		console.log '+ user ' + socket.id + ' connected + domain: ' + domain + ' IP: ' + ip

		socket.on 'disconnect', ->
			authenticatedUsers[socket.id] = undefined
			io.to('auth-users').emit 'update-users', authenticatedUsers
			console.log '- user ' + socket.id + ' disconnected - ' + domain + ' IP: ' + ip

		sendAdminsUpdate = ->
			db.getAdmins (data) ->
				socket.emit 'users-update', data
		socket.on 'get-users', ->
			sendAdminsUpdate()
		socket.on 'create-user', (data) ->
			db.upsertAdmin data, sendAdminsUpdate

		sendContentGroupsUpdate = ->
			db.getContentGroups (data) ->
				socket.emit 'content-groups-update', data
		socket.on 'get-content-groups', ->
			sendContentGroupsUpdate()
		socket.on 'create-content-group', (data) ->
			db.upsertContentGroup data, sendContentGroupsUpdate

		sendLocalesUpdate = ->
			db.getLocales (data) ->
				socket.emit 'locales-update', data
		socket.on 'get-locales', ->
			sendLocalesUpdate()
		socket.on 'create-locale', (data) ->
			db.upsertLocale data, sendLocalesUpdate

		sendMenusUpdate = ->
			db.getMenus (data) ->
				socket.emit 'menus-update', data
		socket.on 'get-menus', ->
			sendMenusUpdate()
		socket.on 'create-menu', (data) ->
			db.upsertMenu data, sendMenusUpdate

		sendPagesUpdate = ->
			db.getPages (data) ->
				socket.emit 'pages-update', data
		socket.on 'get-pages', ->
			sendPagesUpdate()
		socket.on 'create-page', (data) ->
			db.upsertPage data, sendPagesUpdate


		sendWebsitesUpdate = ->
			db.getWebsites (data) ->
				socket.emit 'websites-update', data
		socket.on 'get-websites', ->
			sendWebsitesUpdate()
		socket.on 'create-website', (data) ->
			db.upsertWebsite data, sendWebsitesUpdate

		socket.on 'user-login', (data) ->
			if data
				models.Admin.findOne({username: data.username, password: data.password}, (err, data) ->
					if data
						socket.join 'auth-users'
						data.password = data.username = data.email = data.__v = undefined
						data.socket = socket.id
						socket.emit 'login-success', data
						authenticatedUsers[socket.id] = data
						io.to('auth-users').emit 'update-users', authenticatedUsers
				)
