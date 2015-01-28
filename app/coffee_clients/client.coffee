sortByName = (a, b) ->
	if a.name > b.name
		return 1
	if a.name < b.name
		return -1
	0

socket = io()

app = angular.module 'wolop-cms', [
	'ngRoute'
	'ui.bootstrap'
	'ui.ace'
	'content-groups'
	'pages'
	'menus'
	'regions-languages'
	'websites'
	'users'
	'navigation'
	'chat'
]

app.config ($routeProvider) ->
	path = $routeProvider.when

	path '/',
		templateUrl: '/partials/home.html'
		controller: 'HomeController'

	path '/websites',
		templateUrl: '/partials/websites.html'
		controller: 'WebsitesController'

	path '/website/:slug',
		templateUrl: '/partials/website-details.html'
		controller: 'WebsiteDetailsController'

	path '/website/:site/content-group/:group',
		templateUrl: '/partials/website-content-group-details.html'
		controller: 'WebsiteContentGroupDetailsController'

	path '/pages',
		templateUrl: '/partials/pages.html'
		controller: 'PagesController'

	path '/menus',
		templateUrl: '/partials/menus.html'
		controller: 'MenusController'

	path '/content-groups',
		templateUrl: '/partials/content-groups.html'
		controller: 'ContentGroupsController'

	path '/regions',
		templateUrl: '/partials/regions.html'
		controller: 'RegionsController'

	path '/languages',
		templateUrl: '/partials/languages.html'
		controller: 'LanguagesController'

	path '/users',
		templateUrl: '/partials/users.html'
		controller: 'UsersController'


app.controller 'CmsController', ($scope, $log) ->
	$scope.isLoggedIn = false
	$scope.userData = {}
	$scope.newUser = {}
	socket.on 'login-success', (data) ->
		$scope.$apply ->
			$scope.userData = data
			$scope.isLoggedIn = true

app.controller 'HomeController', ($scope, $modal, $log) ->
	$scope.site = 'wolop'

app.factory 'globalModel', ->
	model = 
		websites: []
		contentGroups: []
		regions: []
		languages: []
		menus: []
		pages: []
		users: []
		peers: []
		messages: []

	getFromSlug = (arr, slug) ->
		l = arr.length
		while l--
			if arr[l].slug == slug
				return arr[l]

	socket.on 'websites-update', (data) -> 
		data.map (site)->
			site.contentGroups.sort sortByName if site.contentGroups
			site.regions.sort sortByName if site.regions
		model.websites = data.sort sortByName if data
	socket.on 'content-groups-update', (data) -> 
		model.contentGroups = data.sort sortByName
	socket.on 'regions-update', (data) -> 
		data.map (region) ->
			region.languages.sort sortByName if region.languages
		model.regions = data.sort sortByName if data
	socket.on 'languages-update', (data) -> 
		model.languages = data.sort sortByName if data
	socket.on 'menus-update', (data) -> 
		model.menus = data.sort sortByName if data
	socket.on 'pages-update', (data) -> 
		model.pages = data.sort sortByName if data
	socket.on 'users-update', (data) -> 
		model.users = data

	getWebsiteBySlug: (slug) ->
		getFromSlug model.websites, slug
	getContentGroupBySlug: (slug) ->
		getFromSlug model.contentGroups, slug
	getRegionBySug: (slug) ->
		getFromSlug model.region, slug
	getUsers: -> model.users
	getWebsites: -> model.websites
	getContentGroups: -> model.contentGroups
	getRegions: -> model.regions
	getLanguages: -> model.languages
	getMenus: -> model.menus
	getPages: -> model.pages
	getRegion: (id) ->
		l = model.regions.length
		while l--
			if model.regions[l]._id == id
				return model.regions[l]
