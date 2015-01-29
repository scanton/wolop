socket = io()

app = angular.module 'wolop-cms', [
	'ngRoute'
	'ui.bootstrap'
	'ui.ace'
	'config'
	'home'
	'content-groups'
	'pages'
	'menus'
	'regions-languages'
	'websites'
	'users'
	'navigation'
	'chat'
	'global-model'
	'utils'
]

app.controller 'CmsController', ($scope, globalModel, $log) ->
	$scope.isLoggedIn = false
	$scope.userData = {}
	$scope.newUser = {}
	$scope.currentWebsite = ''
	$scope.currentRegion = ''
	$scope.currentRegionName = ''
	$scope.currentLanguage = ''
	$scope.currentLanguageName = ''
	$scope.currentLanguages = []
	$scope.setRegion = (slug) ->
		region = globalModel.getRegionBySlug slug
		$scope.currentRegion = slug
		$scope.currentLanguages = region.languages
		$scope.currentRegionName = region.name
	$scope.setLanguage = (slug) ->
		lang = globalModel.getLanguageBySlug slug
		$scope.currentLanguage = slug
		$scope.currentLanguageName = lang.name
	$scope.setWebsite = (slug) ->
		$scope.currentWebsite = slug
	socket.on 'login-success', (data) ->
		$scope.$apply ->
			$scope.userData = data
			$scope.isLoggedIn = true

