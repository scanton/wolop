Accounts.config
	forbidClientAccountCreation: true

if Meteor.isClient
	Meteor.subscribe 'user-roles'
	Meteor.subscribe 'languages'
	Meteor.subscribe 'regions'
	Meteor.subscribe 'websites'
	Meteor.subscribe 'content-groups'
	Meteor.subscribe 'pages'
	Meteor.subscribe 'menus'
	Meteor.subscribe 'admin-history'
	Meteor.subscribe 'user-presence'
	window.Wolop = Meteor
	window.objectify = (arr) ->
		a = []
		l = arr.length
		while l--
			val = arr[l]
			a.unshift { name: val[0], link: val[1], icon: val[2] }
		return a

if Meteor.isServer
	WebApp.connectHandlers.use (req, res, next) ->
		# add allow origin
		res.setHeader 'Access-Control-Allow-Origin', '*'
		# add headers
		res.setHeader 'Access-Control-Allow-Headers', [
			'Accept'
			'Accept-Charset'
			'Accept-Encoding'
			'Accept-Language'
			'Accept-Datetime'
			'Authorization'
			'Cache-Control'
			'Connection'
			'Cookie'
			'Content-Length'
			'Content-MD5'
			'Content-Type'
			'Date'
			'User-Agent'
			'X-Requested-With'
			'Origin'
		].join(', ')
		next()