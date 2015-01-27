socket = io()
app = angular.module 'menus', []

app.directive 'menusOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/menus-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.menus = globalModel.getMenus()
		socket.on 'menus-update', (data) ->
			$scope.$apply ->
				$scope.menus = data.sort sortByName if data

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