socket = io()
app = angular.module 'pages', []

app.directive 'pagesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/pages-overview.html'
	controller: ($scope, globalModel, sortByName, $log) ->
		$scope.pages = globalModel.getPages()
		socket.on 'pages-update', (data) ->
			$scope.$apply ->
				$scope.pages = data.sort sortByName if data

app.controller 'PagesController', ($scope, $modal, $log) ->
	$scope.showCreatePage = ->
		$modal.open
			templateUrl: '/partials/forms/create-page'
			controller: ($scope, $modalInstance, $log) ->
				$scope.createPage = (data) ->
					socket.emit 'create-page', data
					$modalInstance.dismiss 'form-sumbit'
				$scope.cancel = ->
					$modalInstance.dismiss 'cancel'

app.controller 'EditPageController', ($scope, $routeParams, globalModel, $log) ->
	$scope.pageData = globalModel.getPageBySlug $routeParams.page