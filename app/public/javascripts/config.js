(function() {
  var app;

  app = angular.module('config', []);

  app.config(function($routeProvider, $locationProvider) {
    var path;
    path = $routeProvider.when;
    path('/', {
      templateUrl: '/partials/home.html',
      controller: 'HomeController'
    });
    path('/websites', {
      templateUrl: '/partials/websites.html',
      controller: 'WebsitesController'
    });
    path('/website/:slug', {
      templateUrl: '/partials/website-details.html',
      controller: 'WebsiteDetailsController'
    });
    path('/website/:site/content-group/:group', {
      templateUrl: '/partials/website-content-group-details.html',
      controller: 'WebsiteContentGroupDetailsController'
    });
    path('/pages', {
      templateUrl: '/partials/pages.html',
      controller: 'PagesController'
    });
    path('/edit-page/:page', {
      templateUrl: '/partials/edit-page.html',
      controller: 'EditPageController'
    });
    path('/menus', {
      templateUrl: '/partials/menus.html',
      controller: 'MenusController'
    });
    path('/edit-menu/:menu', {
      templateUrl: '/partials/edit-menu.html',
      controller: 'EditMenuController'
    });
    path('/content-groups', {
      templateUrl: '/partials/content-groups.html',
      controller: 'ContentGroupsController'
    });
    path('/regions', {
      templateUrl: '/partials/regions.html',
      controller: 'RegionsController'
    });
    path('/languages', {
      templateUrl: '/partials/languages.html',
      controller: 'LanguagesController'
    });
    return path('/users', {
      templateUrl: '/partials/users.html',
      controller: 'UsersController'
    });
  });

}).call(this);
