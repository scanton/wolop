socket = io()
app = angular.module 'content-groups', []

app.directive 'contentGroupsOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/content-groups-overview.html'
	controller: ($scope, globalModel, sortByName, $log) ->
		$scope.contentGroups = globalModel.getContentGroups()
		socket.on 'content-groups-update', (data) ->
			$scope.$apply ->
				$scope.contentGroups = data.sort sortByName if data

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