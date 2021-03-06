(function() {
  var app, socket;

  socket = io();

  app = angular.module('content-groups', []);

  app.directive('contentGroupsOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/content-groups-overview.html',
      controller: function($scope, globalModel, sortByName, $log) {
        $scope.contentGroups = globalModel.getContentGroups();
        return socket.on('content-groups-update', function(data) {
          return $scope.$apply(function() {
            if (data) {
              return $scope.contentGroups = data.sort(sortByName);
            }
          });
        });
      }
    };
  });

  app.controller('ContentGroupsController', function($scope, $modal, $log) {
    return $scope.showCreateContentGroup = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-content-group',
        controller: 'CreateContentGroupController'
      });
    };
  });

  app.controller('CreateContentGroupController', function($scope, $modalInstance, $log) {
    $scope.createContentGroup = function(data) {
      socket.emit('create-content-group', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

}).call(this);
