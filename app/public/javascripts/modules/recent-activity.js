(function() {
  var app, socket;

  socket = io();

  app = angular.module('recent-activity', []);

  app.directive('recentActivity', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/recent-activity.html',
      controller: function($scope, globalModel, $log) {
        $scope.recentActivity = globalModel.getRecentActivity();
        return socket.on('recent-activity-update', function(data) {
          return $scope.$apply(function() {
            return $scope.recentActivity = data;
          });
        });
      }
    };
  });

}).call(this);
