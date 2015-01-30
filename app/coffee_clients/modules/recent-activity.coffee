socket = io()
app = angular.module 'recent-activity', []

app.directive 'recentActivity', ->
	restrict: 'E'
	templateUrl: '/partials/directives/recent-activity.html'
	controller: ($scope, globalModel, $log) ->
		$scope.recentActivity = globalModel.getRecentActivity()
		socket.on 'recent-activity-update', (data) ->
			$scope.$apply ->
				$scope.recentActivity = data
