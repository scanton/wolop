pages = [
	['Home', 'home', 'home']
	['Pages', 'pages', 'duplicate']
	#['Static Text', 'static-text', 'text-height']
	#['Products', 'products', 'shopping-cart']
	#['Notices', 'notices', 'comment']
	['Menus', 'menus', 'th-list']
	['Websites', 'websites', 'globe']
	['Content Groups', 'content-groups', 'book']
	['Regions', 'regions', 'flag']
	['Languages', 'languages', 'yen']
	#['Users', 'users', 'user']
]
routeNames = []

if Meteor.isClient
	Session.set 'pages', pages
	Template.registerHelper 'navData', ->
		objectify pages

Router.configure
	layoutTemplate: 'layout'
	notFoundTemplate: 'not-found'
	loadingTemplate: 'loading'

Router.map ->

	l = pages.length
	while l--
		path = pages[l][1]
		@route path,
			routeNames.push path
			path: '/' + path
			template: path
			subscriptions: ->
				Meteor.subscribe path

	@route 'root',
		path: '/'
		template: 'home'
		subscriptions: ->
			#Meteor.subscribe

	@route 'logout',
		path: '/logout'
		template: 'logout'
		action: ->
			Meteor.logoutOtherClients()
			Meteor.logout()
			Router.go '/'

requiresLogin = ->
	if !Meteor.user() or !Meteor.user().roles || !Meteor.user().roles.admin
		@render 'loginRequired'
	else
		@next()

Router.onBeforeAction requiresLogin, {only: routeNames}
