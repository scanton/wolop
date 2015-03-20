pages = [
	['Home', 'home', 'home']
	#['Static Text', 'static-text', 'text-height']
	#['Products', 'products', 'shopping-cart']
	#['Notices', 'notices', 'comment']
	['Websites', 'websites', 'globe']
	['Content Groups', 'content-groups', 'book']
	['Pages', 'pages', 'duplicate']
	['Menus', 'menus', 'th-list']
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

	@route 'edit-website-content-group',
		routeNames.push 'edit-website-content-group'
		path: '/edit-website-content-group/:website/:group'
		template: 'edit-website-content-group'
		data: ->
			group: @params.group
			website: @params.website

	@route 'edit-menu-details',
		routeNames.push 'edit-menu-details'
		path: '/edit-menu-details/:menu/:contentGroup'
		template: 'edit-menu-details'
		data: ->
			menu: @params.menu
			group: @params.contentGroup

	@route 'edit-page-localization',
		routeNames.push 'edit-page-localization'
		path: '/edit-page-localization/:page/:contentGroup'
		template: 'edit-page-localization'
		data: ->
			page: @params.page
			group: @params.contentGroup

	@route 'website-details',
		routeNames.push 'website-details'
		path: 'website-details/:slug'
		template: 'website-details'
		data: ->
			slug: @params.slug

requiresLogin = ->
	if !Meteor.user() or !Meteor.user().roles || !Meteor.user().roles.admin
		@render 'loginRequired'
	else
		@next()

Router.onBeforeAction requiresLogin, {only: routeNames}
