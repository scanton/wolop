(function() {
  var app, socket, sortByName;

  sortByName = function(a, b) {
    if (a.name > b.name) {
      return 1;
    }
    if (a.name < b.name) {
      return -1;
    }
    return 0;
  };

  socket = io();

  app = angular.module('wolop-cms', ['ngRoute', 'ui.bootstrap', 'ui.ace', 'content-groups', 'pages', 'menus', 'regions-languages', 'websites', 'users', 'chat']);

  app.config(function($routeProvider) {
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
    path('/menus', {
      templateUrl: '/partials/menus.html',
      controller: 'MenusController'
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

  app.controller('CmsController', function($scope, $log) {
    $scope.isLoggedIn = false;
    $scope.userData = {};
    $scope.newUser = {};
    return socket.on('login-success', function(data) {
      return $scope.$apply(function() {
        $scope.userData = data;
        return $scope.isLoggedIn = true;
      });
    });
  });

  app.controller('HomeController', function($scope, $modal, $log) {
    return $scope.site = 'wolop';
  });

  app.factory('globalModel', function() {
    var model;
    model = {
      websites: [],
      contentGroups: [],
      regions: [],
      languages: [],
      menus: [],
      pages: [],
      users: [],
      peers: [],
      messages: []
    };
    socket.on('websites-update', function(data) {
      data.map(function(site) {
        if (site.contentGroups) {
          site.contentGroups.sort(sortByName);
        }
        if (site.regions) {
          return site.regions.sort(sortByName);
        }
      });
      if (data) {
        return model.websites = data.sort(sortByName);
      }
    });
    socket.on('content-groups-update', function(data) {
      return model.contentGroups = data.sort(sortByName);
    });
    socket.on('regions-update', function(data) {
      data.map(function(region) {
        if (region.languages) {
          return region.languages.sort(sortByName);
        }
      });
      if (data) {
        return model.regions = data.sort(sortByName);
      }
    });
    socket.on('languages-update', function(data) {
      if (data) {
        return model.languages = data.sort(sortByName);
      }
    });
    socket.on('menus-update', function(data) {
      if (data) {
        return model.menus = data.sort(sortByName);
      }
    });
    socket.on('pages-update', function(data) {
      if (data) {
        return model.pages = data.sort(sortByName);
      }
    });
    socket.on('users-update', function(data) {
      return model.users = data;
    });
    return {
      getUsers: function() {
        return model.users;
      },
      getWebsites: function() {
        return model.websites;
      },
      getContentGroups: function() {
        return model.contentGroups;
      },
      getRegions: function() {
        return model.regions;
      },
      getLanguages: function() {
        return model.languages;
      },
      getMenus: function() {
        return model.menus;
      },
      getPages: function() {
        return model.pages;
      },
      getRegion: function(id) {
        var l;
        l = model.regions.length;
        while (l--) {
          if (model.regions[l]._id === id) {
            return model.regions[l];
          }
        }
      }
    };
  });

  app.directive('navBar', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/nav-bar.html',
      controller: function($scope, $location, $log) {
        $scope.path = $location.path();
        $scope.$on('$locationChangeStart', function(event, next, current) {
          return $scope.path = next.split('#')[1];
        });
        return $scope.navData = [
          {
            label: 'Websites',
            link: '/websites'
          }, {
            label: 'Content Groups',
            link: '/content-groups'
          }, {
            label: 'Regions',
            link: '/regions'
          }, {
            label: 'Languages',
            link: '/languages'
          }, {
            label: 'Users',
            link: '/users'
          }
        ];
      }
    };
  });

}).call(this);
