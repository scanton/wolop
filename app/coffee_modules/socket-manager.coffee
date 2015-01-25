_und = require 'underscore'
models = require '../coffee_modules/models'
db = require '../coffee_modules/data-api'
authenticatedUsers = {}

websites = []
contentGroups = []
regions = []
languages = []
menus = []
pages = []
users = []

db.getWebsites (data) -> websites = data
db.getContentGroups (data) -> contentGroups = data
db.getRegions (data) -> regions = data
db.getLanguages (data) -> languages = data
db.getMenus (data) -> menus = data
db.getPages (data) -> pages = data
db.getAdmins (data) -> users = data

module.exports = (io) ->

	refreshWebsites = ->
		db.getWebsites (data) -> 
			websites = data
			io.to('auth-users').emit 'websites-update', data

	io.on 'connection', (socket) ->

		socket.join 'all-users'

		domain = socket.handshake.headers.host.split(':')[0]
		ip = socket.client.conn.remoteAddress

		console.log '+ user ' + socket.id + ' connected + domain: ' + domain + ' IP: ' + ip

		socket.on 'disconnect', ->
			authenticatedUsers[socket.id] = undefined
			io.to('auth-users').emit 'auth-users-update', authenticatedUsers
			console.log '- user ' + socket.id + ' disconnected - ' + domain + ' IP: ' + ip

		socket.on 'chat-message', (message) ->
			io.to('auth-users').emit 'chat-message-update', {user: authenticatedUsers[socket.id], message: message}

		socket.on 'working-on', (str) ->
			if str && authenticatedUsers[socket.id]
				x = authenticatedUsers[socket.id]
				y =
					_id: x._id
					firstName: x.firstName
					lastName: x.lastName
					workingOn: str
				authenticatedUsers[socket.id] = y
				io.to('auth-users').emit 'auth-users-update', authenticatedUsers
				console.log y

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

		socket.on 'create-region', (data) ->
			db.upsertRegion data, ->
				db.getRegions (data) ->
					regions = data
					io.to('auth-users').emit 'regions-update', data

		socket.on 'create-language', (data) ->
			db.upsertLanguage data, ->
				db.getLanguages (data) ->
					languages = data
					io.to('auth-users').emit 'languages-update', data

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
				refreshWebsites()

		socket.on 'add-content-group', (data) ->
			if data && data.website
				db.getWebsite {slug: data.website}, (site) ->
					site.contentGroups = [] if !site.contentGroups
					site.contentGroups.push
						name: data.name
						slug: data.slug
					db.updateWebsiteContentGroups data.website, {contentGroups: site.contentGroups}, ->
						refreshWebsites()

		socket.on 'add-region', (data) ->
			if data && data.website
				db.getWebsite {slug: data.website}, (site) ->
					site.regions = [] if !site.regions
					site.regions.push
						name: data.name
						slug: data.slug
					db.updateWebsiteRegions data.website, {regions: site.regions}, ->
						refreshWebsites()

		socket.on 'add-language', (data) ->
			if data && data.website
				db.getWebsite {slug: data.website}, (site) ->
					site.languages = [] if !site.languages
					site.languages.push
						name: data.name
						slug: data.slug
					db.updateWebsiteLanguages data.website, {languages: site.languages}, ->
						refreshWebsites()

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
						socket.emit 'regions-update', regions
						socket.emit 'languages-update', languages
						socket.emit 'menus-update', menus
						socket.emit 'pages-update', pages
						socket.emit 'users-update', users
				)
