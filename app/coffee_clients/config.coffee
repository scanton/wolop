app = angular.module 'config', []

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