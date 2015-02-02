(function() {
  var app, socket;

  socket = io();

  app = angular.module('pages', []);

  app.directive('pagesOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/pages-overview.html',
      controller: function($scope, globalModel, sortByName, $log) {
        $scope.pages = globalModel.getPages();
        return socket.on('pages-update', function(data) {
          return $scope.$apply(function() {
            if (data) {
              return $scope.pages = data.sort(sortByName);
            }
          });
        });
      }
    };
  });

  app.controller('PagesController', function($scope, $modal, $log) {
    return $scope.showCreatePage = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-page',
        controller: function($scope, $modalInstance, $log) {
          $scope.createPage = function(data) {
            socket.emit('create-page', data);
            return $modalInstance.dismiss('form-sumbit');
          };
          return $scope.cancel = function() {
            return $modalInstance.dismiss('cancel');
          };
        }
      });
    };
  });

  app.controller('EditPageController', function($scope, $routeParams, globalModel, $log) {
    return $scope.pageData = globalModel.getPageBySlug($routeParams.page);
  });

}).call(this);
