sortByName = (a, b) ->
	if a.name > b.name
		return 1
	if a.name < b.name
		return -1
	0

socket = io()

app = angular.module 'wolop-cms', [
	'ngRoute'
	'ui.bootstrap'
	'ui.ace'
	'chat'
]

app.controller 'CmsController', ($scope, $log) ->
	$scope.isLoggedIn = false
	$scope.userData = {}
	$scope.newUser = {}
	socket.on 'login-success', (data) ->
		$scope.$apply ->
			$scope.userData = data
			$scope.isLoggedIn = true

app.factory 'globalModel', ->
	model = 
		websites: []
		contentGroups: []
		regions: []
		languages: []
		menus: []
		pages: []
		users: []
		peers: []
		messages: []

	socket.on 'websites-update', (data) -> 
		data.map (site)->
			site.contentGroups.sort sortByName
			site.regions.sort sortByName
		model.websites = data.sort sortByName
	socket.on 'content-groups-update', (data) -> 
		model.contentGroups = data.sort sortByName
	socket.on 'regions-update', (data) -> 
		model.regions = data.sort sortByName
	socket.on 'languages-update', (data) -> 
		model.languages = data.sort sortByName
	socket.on 'menus-update', (data) -> 
		model.menus = data.sort sortByName
	socket.on 'pages-update', (data) -> 
		model.pages = data.sort sortByName
	socket.on 'users-update', (data) -> 
		model.users = data

	getUsers: -> model.users
	getWebsites: -> model.websites
	getContentGroups: -> model.contentGroups
	getRegions: -> model.regions
	getLanguages: -> model.languages
	getMenus: -> model.menus
	getPages: -> model.pages

app.directive 'userLogin', ->
	restrict: 'E'
	templateUrl: '/partials/directives/user-login.html'
	controller: ($scope, $log) ->
		$scope.loginData = {}
		$scope.userLogin = (data) ->
			socket.emit 'user-login', data

app.directive 'createUser', ->
	restrict: 'E'
	templateUrl: '/partials/directives/create-user.html'
	controller: ($scope, $log) ->
		$scope.createUserData = {}
		$scope.createUser = (data) ->
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
			{label: 'Products', link: '/products'}
			{label: 'Content Groups', link: '/content-groups'}
		#	{label: 'Pages', link: '/pages'}
		#	{label: 'Menus', link: '/menus'}
			{label: 'Static Text', link: '/static-text'}
			{label: 'Regions', link: '/regions'}
			{label: 'Languages', link: '/languages'}
			{label: 'Users', link: '/users'}
			{label: 'Notices', link: '/notices'}
		]

app.directive 'usersOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/users-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.users = globalModel.getUsers()
		socket.on 'users-update', (data) -> 
			$scope.$apply ->
				$scope.users = data
		
app.directive 'contentGroupsOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/content-groups-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.contentGroups = globalModel.getContentGroups()
		socket.on 'content-groups-update', (data) ->
			$scope.$apply ->
				$scope.contentGroups = data.sort sortByName

app.directive 'regionsOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/regions-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.regions = globalModel.getRegions()
		socket.on 'regions-update', (data) ->
			$scope.$apply ->
				$scope.regions = data.sort sortByName

app.directive 'languagesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/languages-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.languages = globalModel.getLanguages()
		socket.on 'languages-update', (data) ->
			$scope.$apply ->
				$scope.languages = data.sort sortByName

app.directive 'menusOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/menus-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.menus = globalModel.getMenus()
		socket.on 'menus-update', (data) ->
			$scope.$apply ->
				$scope.menus = data.sort sortByName

app.directive 'pagesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/pages-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.pages = globalModel.getPages()
		socket.on 'pages-update', (data) ->
			$scope.$apply ->
				$scope.pages = data.sort sortByName

app.directive 'websitesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/websites-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.websites = globalModel.getWebsites()
		socket.on 'websites-update', (data) ->
			$scope.$apply ->
				data.map (site)->
					site.contentGroups.sort sortByName
					site.regions.sort sortByName
				$scope.websites = data.sort sortByName

app.config ($routeProvider) ->
	path = $routeProvider.when

	path '/',
		templateUrl: '/partials/home.html'
		controller: 'HomeController'

	path '/websites',
		templateUrl: '/partials/websites.html'
		controller: 'WebsitesController'

	path '/website/:slug',
		templateUrl: '/partials/website-details.html'
		controller: 'WebsiteDetailsController'

	path '/website/:site/content-group/:group',
		templateUrl: '/partials/website-content-group-details.html'
		controller: 'WebsiteContentGroupDetailsController'

	path '/pages',
		templateUrl: '/partials/pages.html'
		controller: 'PagesController'

	path '/menus',
		templateUrl: '/partials/menus.html'
		controller: 'MenusController'

	path '/content-groups',
		templateUrl: '/partials/content-groups.html'
		controller: 'ContentGroupsController'

	path '/regions',
		templateUrl: '/partials/regions.html'
		controller: 'RegionsController'

	path '/languages',
		templateUrl: '/partials/languages.html'
		controller: 'LanguagesController'

	path '/users',
		templateUrl: '/partials/users.html'
		controller: 'UsersController'

app.controller 'HomeController', ($scope, $modal, $log) ->
	#$log.info 'home-controller'

#websites
app.controller 'WebsitesController', ($scope, $modal, globalModel, $log) ->
	
	$scope.contentGroups = globalModel.getContentGroups()
	socket.on 'content-groups-update', (data) ->
		$scope.$apply ->
			$scope.contentGroups = data.sort sortByName

	$scope.regions = globalModel.getRegions()
	socket.on 'regions-update', (data) ->
		$scope.$apply ->
			$scope.regions = data.sort sortByName

	$scope.addContentGroup = (slug) ->
		$scope.addContentGroupData = 
			website: slug
		$modal.open
			templateUrl: '/partials/forms/add-content-group'
			controller: 'AddContentGroupController'
			scope: $scope
	$scope.addRegion = (slug, regionId) ->
		$scope.addRegionData = 
			website: slug
			regionId: regionId
		$modal.open
			templateUrl: '/partials/forms/add-region'
			controller: 'AddRegionController'
			scope: $scope
	$scope.showCreateWebsite = ->
		$modal.open
			templateUrl: '/partials/forms/create-website'
			controller: 'CreateWebsiteController'

app.controller 'WebsiteDetailsController', ($scope, $routeParams, $log) ->
	index = $routeParams.slug
	$scope.index = index
	socket.emit 'working-on', index

app.controller 'WebsiteContentGroupDetailsController', ($scope, $routeParams, $log) ->
	site = $routeParams.site
	group = $routeParams.group
	socket.emit 'working-on', site + ' (' + group + ')'
	$scope.params = $routeParams

app.controller 'CreateWebsiteController', ($scope, $modalInstance, $log) ->
	$scope.createWebsite = (data) ->
		socket.emit 'create-website', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

#pages
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

#menus
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

#content groups
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

app.controller 'AddContentGroupController', ($scope, $modalInstance, $log) ->
	$scope.addContentGroup = (site, contentGroupId) ->
		socket.emit 'add-content-group', {website: site, contentGroupId: contentGroupId}
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

#regions
app.controller 'AddRegionController', ($scope, $modalInstance, $log) ->
	$scope.addRegion = (site, regionId) ->
		socket.emit 'add-region', {website: site, regionId: regionId}
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'RegionsController', ($scope, $modal, $log) ->
	$scope.showCreateRegion = ->
		$modal.open
			templateUrl: '/partials/forms/create-region'
			controller: 'CreateRegionController'

app.controller 'CreateRegionController', ($scope, $modalInstance, $log) ->
	$scope.createRegion = (data) ->
		socket.emit 'create-region', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

#languages
app.controller 'AddLanguageController', ($scope, $modalInstance, $log) ->
	$scope.addLanguage = (data) ->
		socket.emit 'add-language', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'LanguagesController', ($scope, $modal, $log) ->
	$scope.showCreateLanguage = ->
		$modal.open
			templateUrl: '/partials/forms/create-language'
			controller: 'CreateLanguageController'

app.controller 'CreateLanguageController', ($scope, $modalInstance, $log) ->
	$scope.createLanguage = (data) ->
		socket.emit 'create-language', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

#users
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
