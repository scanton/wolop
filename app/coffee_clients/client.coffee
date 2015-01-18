socket = io()
currentScope = undefined

websites = []
contentGroups = []
locales = []
menus = []
pages = []
users = []

socket.on 'websites-update', (data) -> websites = data
socket.on 'content-groups-update', (data) -> contentGroups = data
socket.on 'locales-update', (data) -> locales = data
socket.on 'menus-update', (data) -> menus = data
socket.on 'pages-update', (data) -> pages = data
socket.on 'users-update', (data) -> users = data

app = angular.module 'wolop-cms', ['ui.bootstrap', 'ngRoute', 'ui.ace']

app.controller 'CmsController', ($scope, $log) ->
	$scope.isLoggedIn = false
	$scope.userData = {}
	$scope.newUser = {}
	socket.on 'login-success', (data) ->
		$scope.$apply ->
			$scope.userData = data
			$scope.isLoggedIn = true

app.directive 'chatWidget', ->
	restrict: 'E'
	templateUrl: '/partials/directives/chat-widget.html'
	controller: ($scope, $log) ->
		$scope.peers = {}
		$scope.chatArray = []
		$scope.sendMessage = (message) ->
			socket.emit 'chat-message', message
		socket.on 'chat-message-update', (data) ->
			$scope.$apply ->
				$scope.chatArray.push data
		socket.on 'auth-users-update', (data) ->
			$scope.$apply ->
				$scope.peers = data

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
			$log.info data
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
			{label: 'Pages', link: '/pages'}
			{label: 'Menus', link: '/menus'}
			{label: 'Content Groups', link: '/content-groups'}
			{label: 'Locales', link: '/locales'}
			{label: 'Users', link: '/users'}
		]

app.directive 'usersOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/users-overview.html'
	controller: ($scope, $log) ->
		$scope.users = users

app.directive 'contentGroupsOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/content-groups-overview.html'
	controller: ($scope, $log) ->
		$scope.contentGroups = contentGroups

app.directive 'localesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/locales-overview.html'
	controller: ($scope, $log) ->
		$scope.locales = locales

app.directive 'menusOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/menus-overview.html'
	controller: ($scope, $log) ->
		$scope.menus = menus

app.directive 'pagesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/pages-overview.html'
	controller: ($scope, $log) ->
		$scope.pages = pages

app.directive 'websitesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/websites-overview.html'
	controller: ($scope, $log) ->
		$scope.websites = websites

app.config ($routeProvider) ->
	path = $routeProvider.when

	path '/',
		templateUrl: '/partials/home.html'
		controller: 'HomeController'

	path '/websites',
		templateUrl: '/partials/websites.html'
		controller: 'WebsitesController'

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

app.controller 'WebsitesController', ($scope, $modal, $log) ->
	socket.emit 'get-websites'
	$scope.showCreateWebsite = ->
		$modal.open
			templateUrl: '/partials/forms/create-website'
			controller: 'CreateWebsiteController'

app.controller 'CreateWebsiteController', ($scope, $modalInstance, $log) ->
	$scope.createWebsite = (data) ->
		socket.emit 'create-website', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'PagesController', ($scope, $modal, $log) ->
	socket.emit 'get-pages'
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

app.controller 'MenusController', ($scope, $modal, $log) ->
	socket.emit 'get-menus'
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

app.controller 'ContentGroupsController', ($scope, $modal, $log) ->
	socket.emit 'get-content-groups'
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

app.controller 'LocalesController', ($scope, $modal, $log) ->
	socket.emit 'get-locales'
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

app.controller 'UsersController', ($scope, $modal, $log) ->
	socket.emit 'get-users'
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
