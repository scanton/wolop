(function() {
  var app, socket;

  socket = io();

  app = angular.module('wolop-cms', ['ngRoute']);

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
    return path('/users', {
      templateUrl: '/partials/users.html',
      controller: 'UsersController'
    });
  });

  app.controller('HomeController', function($scope) {
    return console.log('home-controller');
  });

  app.controller('WebsitesController', function($scope) {
    return console.log('websites-controller');
  });

  app.controller('PagesController', function($scope) {
    return console.log('pages-controller');
  });

  app.controller('MenusController', function($scope) {
    return console.log('menus-controller');
  });

  app.controller('ContentGroupsController', function($scope) {
    return console.log('content-groups-controller');
  });

  app.controller('UsersController', function($scope) {
    return console.log('users-controller');
  });

  app.controller('CmsController', function($scope) {
    $scope.isLoggedIn = false;
    $scope.userData = {};
    $scope.newUser = {};
    $scope.addUser = function(data) {
      return socket.emit('add-new-user', data);
    };
    return socket.on('login-success', function(data) {
      return $scope.$apply(function() {
        $scope.userData = data;
        return $scope.isLoggedIn = true;
      });
    });
  });

  app.directive('userLogin', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/user-login.html',
      controller: function($scope) {
        $scope.loginData = {};
        return $scope.userLogin = function(data) {
          return socket.emit('user-login', data);
        };
      }
    };
  });

  app.directive('createUser', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/create-user.html',
      controller: function($scope) {
        $scope.createUserData = {};
        return $scope.createUser = function(data) {
          return socket.emit('create-user', data);
        };
      }
    };
  });

}).call(this);
