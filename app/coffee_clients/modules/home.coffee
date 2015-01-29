socket = io()
app = angular.module 'home', []

app.controller 'HomeController', ($scope, $modal, $log) ->
	$scope.site = 'wolop'