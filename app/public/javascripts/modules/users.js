(function() {
  var app, socket;

  socket = io();

  app = angular.module('users', []);

  app.directive('userLogin', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/user-login.html',
      controller: function($scope, $log) {
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
          return socket.emit('create-user', data);
        };
      }
    };
  });

  app.directive('usersOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/users-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.users = globalModel.getUsers();
        return socket.on('users-update', function(data) {
          return $scope.$apply(function() {
            return $scope.users = data;
          });
        });
      }
    };
  });

  app.controller('UsersController', function($scope, $modal, $log) {
    return $scope.showCreateUser = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-user',
        controller: 'CreateUserController'
      });
    };
  });

  app.controller('CreateUserController', function($scope, $modalInstance, $log) {
    $scope.createUserData = {};
    $scope.createUser = function(data) {
      socket.emit('create-user', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

}).call(this);
