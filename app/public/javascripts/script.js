(function() {
  var app, socket;

  socket = io();

  app = angular.module('wolop-cms', ['ui.bootstrap', 'ngRoute', 'ui.ace']);

  app.controller('CmsController', function($scope) {
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

  app.directive('userLogin', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/user-login.html',
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
      templateUrl: '/partials/directives/create-user.html',
      controller: function($scope, $log) {
        $scope.createUserData = {};
        return $scope.createUser = function(data) {
          $log.info(data);
          return socket.emit('create-user', data);
        };
      }
    };
  });

  app.directive('navBar', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/nav-bar.html',
      controller: function($scope, $location, $log) {
        $log.info($location.path());
        $scope.path = $location.path();
        $scope.$on('$locationChangeStart', function(event, next, current) {
          return $scope.path = next.split('#')[1];
        });
        return $scope.navData = [
          {
            label: 'Websites',
            link: '/websites'
          }, {
            label: 'Pages',
            link: '/pages'
          }, {
            label: 'Menus',
            link: '/menus'
          }, {
            label: 'Content Groups',
            link: '/content-groups'
          }, {
            label: 'Users',
            link: '/users'
          }
        ];
      }
    };
  });

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

  app.controller('HomeController', function($scope, $modal, $log) {
    return $log.info('home-controller');
  });

  app.controller('WebsitesController', function($scope, $modal, $log) {
    return $log.info('websites-controller');
  });

  app.controller('PagesController', function($scope, $modal, $log) {
    return $log.info('pages-controller');
  });

  app.controller('MenusController', function($scope, $modal, $log) {
    return $log.info('menus-controller');
  });

  app.controller('ContentGroupsController', function($scope, $modal, $log) {
    return $log.info('content-groups-controller');
  });

  app.controller('UsersController', function($scope, $modal, $log) {
    $log.info('users-controller');
    return $scope.showCreateUser = function() {
      return $modal.open({
        templateUrl: '/partials/directives/create-user',
        controller: 'CreateUserController'
      });
    };
  });

  app.controller('CreateUserController', function($scope, $modalInstance) {
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

}).call(this);
