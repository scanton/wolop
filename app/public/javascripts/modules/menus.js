(function() {
  var app, socket;

  socket = io();

  app = angular.module('menus', []);

  app.directive('menusOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/menus-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.menus = globalModel.getMenus();
        return socket.on('menus-update', function(data) {
          return $scope.$apply(function() {
            if (data) {
              return $scope.menus = data.sort(sortByName);
            }
          });
        });
      }
    };
  });

  app.controller('MenusController', function($scope, $modal, $log) {
    return $scope.showCreateMenu = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-menu',
        controller: function($scope, $modalInstance, $log) {
          $scope.createMenu = function(data) {
            socket.emit('create-menu', data);
            return $modalInstance.dismiss('form-sumbit');
          };
          return $scope.cancel = function() {
            return $modalInstance.dismiss('cancel');
          };
        }
      });
    };
  });

  app.controller('EditMenuController', function($scope, $routeParams, globalModel, $log) {
    return $scope.menuData = globalModel.getMenuBySlug($routeParams.menu);
  });

}).call(this);
