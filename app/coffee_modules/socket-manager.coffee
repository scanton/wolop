_und = require 'underscore'
models = require '../coffee_modules/models.coffee'
authenticatedUsers = {}

module.exports = (io) ->

	io.on 'connection', (socket) ->

		domain = socket.handshake.headers.host.split(':')[0]
		ip = socket.client.conn.remoteAddress

		console.log '+ user ' + socket.id + ' connected + domain: ' + domain + ' IP: ' + ip

		socket.on 'disconnect', ->
			console.log '- user ' + socket.id + ' disconnected - ' + domain + ' IP: ' + ip

		sendAdminsUpdate = ->
			models.Admin.find(
				{}
				(err, data) ->
					socket.emit 'users-update', data
			).exec()
		sendContentGroupsUpdate = ->
			models.ContentGroup.find(
				{}
				(err, data) ->
					socket.emit 'content-groups-update', data
			).exec()
		sendLocalesUpdate = ->
			models.Locale.find(
				{}
				(err, data) ->
					socket.emit 'locales-update', data
			).exec()
		sendMenusUpdate = ->
			models.Menu.find(
				{}
				(err, data) ->
					socket.emit 'menus-update', data
			).exec()
		sendPagesUpdate = ->
			models.Page.find(
				{}
				(err, data) ->
					socket.emit 'pages-update', data
			).exec()
		sendWebsitesUpdate = ->
			models.Website.find(
				{}
				(err, data) ->
					socket.emit 'websites-update', data
			).exec()

		socket.on 'get-users', ->
			sendAdminsUpdate()
		socket.on 'get-content-groups', ->
			sendContentGroupsUpdate()
		socket.on 'get-locales', ->
			sendLocalesUpdate()
		socket.on 'get-menus', ->
			sendMenusUpdate()
		socket.on 'get-pages', ->
			sendPagesUpdate()
		socket.on 'get-websites', ->
			sendWebsitesUpdate()
		socket.on 'user-login', (data) ->
			if data
				models.Admin.findOne({username: data.username, password: data.password}, (err, data) ->
					if data
						data.password = '***************'
						socket.emit 'login-success', data
						authenticatedUsers[socket.id] = data
						socket.emit 'new-users', authenticatedUsers
				)
		socket.on 'create-user', (data) ->
			if data && data.email
				console.log data
				models.Admin.findOneAndUpdate(
					{email: data.email}
					{$set: data}
					{upsert: true}
					(err, rows) ->
						console.log err if err
						sendAdminsUpdate()
				).exec()
		socket.on 'create-website', (data) ->
			if data && data.slug
				console.log data
				models.Website.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
					(err, rows) ->
						console.log err if err
						sendWebsitesUpdate()
				)
		socket.on 'create-page', (data) ->
			if data && data.slug
				console.log data
				models.Page.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
					(err, rows) ->
						console.log err if err
						sendPagesUpdate()
				).exec()
		socket.on 'create-content-group', (data) ->
			if data && data.slug
				console.log data
				models.ContentGroup.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
					(err, rows) ->
						console.log err if err
						sendContentGroupsUpdate()
				).exec()
		socket.on 'create-locale', (data) ->
			if data && data.slug
				console.log data
				models.Locale.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
					(err, rows) ->
						console.log err if err
						sendLocalesUpdate()
				).exec()
		socket.on 'create-menu', (data) ->
			if data && data.slug
				console.log data
				models.Menu.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
					(err, rows) ->
						console.log err if err
						sendMenusUpdate()
				).exec()
