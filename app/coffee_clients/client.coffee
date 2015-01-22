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
	'chat'
]

app.controller 'CmsController', ($scope, $log) ->
	$scope.isLoggedIn = false
	$scope.userData = {}
	$scope.newUser = {}
	socket.on 'login-success', (data) ->
		$scope.$apply ->
			$scope.userData = data
			$scope.isLoggedIn = true

app.factory 'globalModel', ->
	model = 
		websites: []
		contentGroups: []
		locales: []
		menus: []
		pages: []
		users: []
		peers: []
		messages: []

	socket.on 'websites-update', (data) -> 
		model.websites = data.sort sortByName
	socket.on 'content-groups-update', (data) -> 
		model.contentGroups = data
	socket.on 'locales-update', (data) -> 
		model.locales = data
	socket.on 'menus-update', (data) -> 
		model.menus = data
	socket.on 'pages-update', (data) -> 
		model.pages = data
	socket.on 'users-update', (data) -> 
		model.users = data

	getUsers: -> model.users
	getWebsites: -> model.websites
	getContentGroups: -> model.contentGroups
	getLocales: -> model.locales
	getMenus: -> model.menus
	getPages: -> model.pages

app.directive 'userLogin', ->
	restrict: 'E'
	templateUrl: '/partials/directives/user-login.html'
	controller: ($scope, $log) ->
		$scope.loginData = {}
		$scope.userLogin = (data) ->
			socket.emit 'user-login', data

app.directive 'createUser', ->
	restrict: 'E'
	templateUrl: '/partials/directives/create-user.html'
	controller: ($scope, $log) ->
		$scope.createUserData = {}
		$scope.createUser = (data) ->
			socket.emit 'create-user', data

app.directive 'navBar', ->
	restrict: 'E'
	templateUrl: '/partials/directives/nav-bar.html'
	controller: ($scope, $location, $log) ->
		$scope.path = $location.path()
		$scope.$on '$locationChangeStart', (event, next, current) ->
			$scope.path = next.split('#')[1]
		$scope.navData = [
			{label: 'Websites', link: '/websites'}
		#	{label: 'Content Groups', link: '/content-groups'}
		#	{label: 'Pages', link: '/pages'}
		#	{label: 'Locales', link: '/locales'}
		#	{label: 'Menus', link: '/menus'}
			{label: 'Users', link: '/users'}
		]

app.directive 'usersOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/users-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.users = globalModel.getUsers()
		socket.on 'users-update', (data) -> 
			$scope.$apply ->
				$scope.users = data
		
app.directive 'contentGroupsOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/content-groups-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.contentGroups = globalModel.getContentGroups()
		socket.on 'content-groups-update', (data) ->
			$scope.$apply ->
				$scope.contentGroups = data

app.directive 'localesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/locales-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.locales = globalModel.getLocales()
		socket.on 'locales-update', (data) ->
			$scope.$apply ->
				$scope.locales = data

app.directive 'menusOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/menus-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.menus = globalModel.getMenus()
		socket.on 'menus-update', (data) ->
			$scope.$apply ->
				$scope.menus = data

app.directive 'pagesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/pages-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.pages = globalModel.getPages()
		socket.on 'pages-update', (data) ->
			$scope.$apply ->
				$scope.pages = data

app.directive 'websitesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/websites-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.websites = globalModel.getWebsites()
		socket.on 'websites-update', (data) ->
			$scope.$apply ->
				$scope.websites = data.sort sortByName

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

	path '/locales',
		templateUrl: '/partials/locales.html'
		controller: 'LocalesController'

	path '/users',
		templateUrl: '/partials/users.html'
		controller: 'UsersController'

app.controller 'HomeController', ($scope, $modal, $log) ->
	#$log.info 'home-controller'

#websites
app.controller 'WebsitesController', ($scope, $modal, $log) ->
	$scope.addContentGroup = (slug) ->
		$scope.addContentGroupData = 
			website: slug
		$modal.open
			templateUrl: '/partials/forms/add-content-group'
			controller: 'AddContentGroupController'
			scope: $scope
	$scope.addLocale = (slug) ->
		$scope.addLocaleData = 
			website: slug
		$modal.open
			templateUrl: '/partials/forms/add-locale'
			controller: 'AddLocaleController'
			scope: $scope
	$scope.showCreateWebsite = ->
		$modal.open
			templateUrl: '/partials/forms/create-website'
			controller: 'CreateWebsiteController'

app.controller 'WebsiteDetailsController', ($scope, $routeParams, $log) ->
	index = $routeParams.slug
	$scope.index = index
	socket.emit 'working-on', index

app.controller 'WebsiteContentGroupDetailsController', ($scope, $routeParams, $log) ->
	site = $routeParams.site
	group = $routeParams.group
	socket.emit 'working-on', site + ' (' + group + ')'
	$scope.params = $routeParams

app.controller 'CreateWebsiteController', ($scope, $modalInstance, $log) ->
	$scope.createWebsite = (data) ->
		socket.emit 'create-website', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

#pages
app.controller 'PagesController', ($scope, $modal, $log) ->
	$scope.showCreatePage = ->
		$modal.open
			templateUrl: '/partials/forms/create-page'
			controller: 'CreatePageController'

app.controller 'CreatePageController', ($scope, $modalInstance, $log) ->
	$scope.createPage = (data) ->
		socket.emit 'create-page', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

#menus
app.controller 'MenusController', ($scope, $modal, $log) ->
	$scope.showCreateMenu = ->
		$modal.open
			templateUrl: '/partials/forms/create-menu'
			controller: 'CreateMenuController'

app.controller 'CreateMenuController', ($scope, $modalInstance, $log) ->
	$scope.createMenu = (data) ->
		socket.emit 'create-menu', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

#content groups
app.controller 'ContentGroupsController', ($scope, $modal, $log) ->
	$scope.showCreateContentGroup = ->
		$modal.open
			templateUrl: '/partials/forms/create-content-group'
			controller: 'CreateContentGroupController'

app.controller 'CreateContentGroupController', ($scope, $modalInstance, $log) ->
	$scope.createContentGroup = (data) ->
		socket.emit 'create-content-group', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'AddContentGroupController', ($scope, $modalInstance, $log) ->
	$scope.addContentGroup = (data) ->
		socket.emit 'add-content-group', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'AddLocaleController', ($scope, $modalInstance, $log) ->
	$scope.addLocale = (data) ->
		socket.emit 'add-locale', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'
#locales
app.controller 'LocalesController', ($scope, $modal, $log) ->
	$scope.showCreateLocale = ->
		$modal.open
			templateUrl: '/partials/forms/create-locale'
			controller: 'CreateLocaleController'

app.controller 'CreateLocaleController', ($scope, $modalInstance, $log) ->
	$scope.createLocale = (data) ->
		socket.emit 'create-locale', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

#users
app.controller 'UsersController', ($scope, $modal, $log) ->
	$scope.showCreateUser = ->
		$modal.open
			templateUrl: '/partials/forms/create-user'
			controller: 'CreateUserController'

app.controller 'CreateUserController', ($scope, $modalInstance, $log) ->
	$scope.createUserData = {}
	$scope.createUser = (data) ->
		socket.emit 'create-user', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'
