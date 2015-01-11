socket = io()
app = angular.module 'wolop-cms', ['ngRoute', 'ui.ace']

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

	path '/users',
		templateUrl: '/partials/users.html'
		controller: 'UsersController'

app.controller 'HomeController', ($scope) ->
	console.log 'home-controller'

app.controller 'WebsitesController', ($scope) ->
	console.log 'websites-controller'

app.controller 'PagesController', ($scope) ->
	console.log 'pages-controller'

app.controller 'MenusController', ($scope) ->
	console.log 'menus-controller'

app.controller 'ContentGroupsController', ($scope) ->
	console.log 'content-groups-controller'

app.controller 'UsersController', ($scope) ->
	console.log 'users-controller'

app.controller 'CmsController', ($scope) ->
	$scope.isLoggedIn = false
	$scope.userData = {}
	$scope.newUser = {}
	$scope.addUser = (data) ->
		socket.emit 'add-new-user', data
	socket.on 'login-success', (data) ->
		$scope.$apply ->
			$scope.userData = data
			$scope.isLoggedIn = true

app.directive 'userLogin', ->
	restrict: 'E'
	templateUrl: '/partials/user-login.html'
	controller: ($scope) ->
		$scope.loginData = {}
		$scope.userLogin = (data) ->
			socket.emit 'user-login', data

app.directive 'createUser', ->
	restrict: 'E'
	templateUrl: '/partials/create-user.html'
	controller: ($scope) ->
		$scope.createUserData = {}
		$scope.createUser = (data) ->
			socket.emit 'create-user', data
