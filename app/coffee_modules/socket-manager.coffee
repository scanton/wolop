_und = require 'underscore'
models = require '../coffee_modules/models'
db = require '../coffee_modules/data-api'	

authenticatedUsers = {}

websites = []
contentGroups = []
regions = []
languages = []
users = []
menus = []
pages = []

db.getWebsites (data) -> websites = data
db.getContentGroups (data) -> contentGroups = data
db.getRegions (data) -> regions = data
db.getLanguages (data) -> languages = data
db.getAdmins (data) -> users = data

module.exports = (io) ->

	refreshWebsites = ->
		db.getWebsites (data) -> 
			websites = data
			io.to('auth-users').emit 'websites-update', data
	refreshRegions = ->
		db.getRegions (data) ->
			regions = data
			io.to('auth-users').emit 'regions-update', data
	refreshContentGroups = ->
		db.getContentGroups (data) ->
			contentGroups = data
			io.to('auth-users').emit 'content-groups-update', data

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

		socket.on 'create-user', (data) ->
			db.upsertAdmin data, ->
				db.getAdmins (data) ->
					io.to('auth-users').emit 'users-update', data

		socket.on 'create-content-group', (data) ->
			db.upsertContentGroup data, ->
				db.getContentGroups (data) ->
					contentGroups = data
					io.to('auth-users').emit 'content-groups-update', data

		putRegion = (data) ->
			db.upsertRegion data, ->
				db.getRegions (data) ->
					regions = data
					io.to('auth-users').emit 'regions-update', data
					refreshWebsites()
		socket.on 'create-region', putRegion
		socket.on 'update-region', putRegion

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
			if data && data.website && data.contentGroupId
				db.getWebsite {slug: data.website}, (site) ->
					site.contentGroups.push data.contentGroupId
					db.updateWebsiteContentGroups data.website, {contentGroups: site.contentGroups}, ->
						refreshWebsites()

		socket.on 'add-region', (data) ->
			if data && data.website && data.regionId
				db.getWebsite {slug: data.website}, (site) ->
					site.regions.push data.regionId
					db.updateWebsiteRegions data.website, {regions: site.regions}, ->
						refreshWebsites()

		socket.on 'add-language-to-region', (data) ->
			if data && data.regionId && data.languageId
				db.getRegion {_id: data.regionId}, (region) ->
					region.languages.push data.languageId
					db.updateRegionLanguages data.regionId, {languages: region.languages}, ->
						refreshRegions()

		socket.on 'add-menu-to-content-group', (data) ->
			if data && data.contentGroupId && data.slug
				db.upsertMenu data, (menu) ->
					db.getContentGroup data.contentGroupId, (group) ->
						group.menus.push menu._id
						db.updateContentGroup data.contentGroupId, {menus: group.menus}, ->
							refreshContentGroups()
		
		socket.on 'add-page-to-content-group', (data) ->
			console.log data
			if data && data.contentGroupId && data.slug
				db.upsertPage data, (page) ->
					console.log page
					db.getContentGroup data.contentGroupId, (group) ->
						console.log group
						group.pages.push page._id
						db.updateContentGroup data.contentGroupId, {pages: group.pages}, ->
							refreshContentGroups()

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
						socket.emit 'users-update', users
				)
