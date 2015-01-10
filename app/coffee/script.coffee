socket = io()
app = angular.module 'wolop-cms', []

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
