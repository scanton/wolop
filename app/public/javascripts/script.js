(function() {
  var app, socket;

  socket = io();

  app = angular.module('wolop-cms', []);

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

}).call(this);
