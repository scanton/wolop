socket = io()
app = angular.module 'wolop-cms', ['ui.bootstrap', 'ngRoute', 'ui.ace']

app.controller 'CmsController', ($scope) ->
	$scope.isLoggedIn = false
	$scope.userData = {}
	$scope.newUser = {}
	socket.on 'login-success', (data) ->
		$scope.$apply ->
			$scope.userData = data
			$scope.isLoggedIn = true

app.directive 'userLogin', ->
	restrict: 'E'
	templateUrl: '/partials/directives/user-login.html'
	controller: ($scope) ->
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

app.directive 'websitesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/websites-overview.html'
	controller: ($scope, $log) ->
		$scope.websites = []
		socket.on 'websites-update', (data) ->
			$scope.$apply ->
				$scope.websites = data

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
