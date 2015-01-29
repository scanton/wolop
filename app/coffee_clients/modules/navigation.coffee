socket = io()
app = angular.module 'navigation', []

app.directive 'navBar', ->
	restrict: 'E'
	templateUrl: '/partials/directives/nav-bar.html'
	controller: ($scope, $location, $log) ->
		$scope.path = $location.path()
		$scope.$on '$locationChangeStart', (event, next, current) ->
			$scope.path = next.split('#')[1]
		$scope.navData = [
			{label: 'Websites', link: '/websites'}
			{label: 'Content Groups', link: '/content-groups'}
		#	{label: 'Pages', link: '/pages'}
		#	{label: 'Menus', link: '/menus'}
			{label: 'Regions', link: '/regions'}
			{label: 'Languages', link: '/languages'}
			{label: 'Static Text', link: '/static-text'}
			{label: 'Users', link: '/users'}
			{label: 'Products', link: '/products'}
			{label: 'Notices', link: '/notices'}
		]
