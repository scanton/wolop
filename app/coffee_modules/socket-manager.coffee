
models = require '../coffee_modules/models.coffee'
module.exports = (io) ->

	io.on 'connection', (socket) ->
		models.Admin.find(
			{}
			(err, allAdmins) ->
				socket.emit 'users-update', allAdmins
		).exec()
		models.Website.find(
			{}
			(err, allWebsites) ->
				socket.emit 'websites-update', allWebsites
		).exec()
		domain = socket.handshake.headers.host.split(':')[0]
		ip = socket.client.conn.remoteAddress
		console.log '+ user connected + domain: ' + domain + ' IP: ' + ip
		socket.on 'disconnect', ->
			console.log '- user disconnected -'
		socket.on 'user-login', (data) ->
			if data
				models.Admin.findOne({username: data.username, password: data.password}, (err, data) ->
					if data
						data.password = '***************'
						socket.emit 'login-success', data
				)
		socket.on 'create-user', (data) ->
			if data && data.email
				console.log data
				models.Admin.findOneAndUpdate(
					{email: data.email}
					{$set: data}
					{upsert: true}
					(err, rows) ->
						models.Admin.find(
							{}
							(err, allAdmins) ->
								socket.emit 'users-update', allAdmins
						)
				).exec()
		socket.on 'create-website', (data) ->
			if data && data.slug
				console.log data
				Website.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
				).exec()
		socket.on 'create-page', (data) ->
			if data && data.slug
				console.log data
				Page.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
				).exec()
		socket.on 'create-content-group', (data) ->
			if data && data.slug
				console.log data
				ContentGroup.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
				).exec()
		socket.on 'create-locale', (data) ->
			if data && data.slug
				console.log data
				Locale.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
				).exec()
		socket.on 'create-menu', (data) ->
			if data && data.slug
				console.log data
				Menu.findOneAndUpdate(
					{slug: data.slug}
					{$set: data}
					{upsert: true}
				).exec()
