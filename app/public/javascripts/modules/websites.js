(function() {
  var app, socket;

  socket = io();

  app = angular.module('websites', []);

  app.directive('websitesOverview', function(sortByName) {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/websites-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.websites = globalModel.getWebsites();
        return socket.on('websites-update', function(data) {
          return $scope.$apply(function() {
            data.map(function(site) {
              if (site.contentGroups) {
                site.contentGroups.sort(sortByName);
              }
              if (site.regions) {
                return site.regions.sort(sortByName);
              }
            });
            if (data) {
              return $scope.websites = data.sort(sortByName);
            }
          });
        });
      }
    };
  });

  app.controller('WebsitesController', function($scope, $modal, globalModel, sortByName, $log) {
    $scope.contentGroups = globalModel.getContentGroups();
    socket.on('content-groups-update', function(data) {
      return $scope.$apply(function() {
        return $scope.contentGroups = data.sort(sortByName);
      });
    });
    $scope.regions = globalModel.getRegions();
    socket.on('regions-update', function(data) {
      data.map(function(region) {
        if (region.languages) {
          return region.languages.sort(sortByName);
        }
      });
      return $scope.$apply(function() {
        return $scope.regions = data.sort(sortByName);
      });
    });
    $scope.addContentGroup = function(slug) {
      $scope.addContentGroupData = {
        website: slug
      };
      return $modal.open({
        templateUrl: '/partials/forms/add-content-group',
        scope: $scope,
        controller: function($scope, $modalInstance, $log) {
          $scope.addContentGroup = function(site, contentGroupId) {
            socket.emit('add-content-group', {
              website: site,
              contentGroupId: contentGroupId
            });
            return $modalInstance.dismiss('form-sumbit');
          };
          return $scope.cancel = function() {
            return $modalInstance.dismiss('cancel');
          };
        }
      });
    };
    $scope.addRegion = function(slug, regionId) {
      $scope.addRegionData = {
        website: slug,
        regionId: regionId
      };
      return $modal.open({
        templateUrl: '/partials/forms/add-region',
        scope: $scope,
        controller: function($scope, $modalInstance, $log) {
          $scope.addRegion = function(site, regionId) {
            socket.emit('add-region', {
              website: site,
              regionId: regionId
            });
            return $modalInstance.dismiss('form-sumbit');
          };
          return $scope.cancel = function() {
            return $modalInstance.dismiss('cancel');
          };
        }
      });
    };
    return $scope.showCreateWebsite = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-website',
        controller: function($scope, $modalInstance, $log) {
          $scope.createWebsite = function(data) {
            socket.emit('create-website', data);
            return $modalInstance.dismiss('form-sumbit');
          };
          return $scope.cancel = function() {
            return $modalInstance.dismiss('cancel');
          };
        }
      });
    };
  });

  app.controller('WebsiteDetailsController', function($scope, $routeParams, $log) {
    var index;
    index = $routeParams.slug;
    $scope.index = index;
    return socket.emit('working-on', index);
  });

  app.controller('WebsiteContentGroupDetailsController', function($scope, $routeParams, $modal, globalModel, $log) {
    $scope.site = globalModel.getWebsiteBySlug($routeParams.site);
    $scope.group = globalModel.getContentGroupBySlug($routeParams.group);
    if ($scope.site && $scope.site.slug && $scope.group && $scope.group.slug) {
      socket.emit('working-on', $scope.site.slug + ' (' + $scope.group.slug + ')');
    }
    $scope.params = $routeParams;
    $scope.showAddMenu = function(contentGroupId) {
      return $modal.open({
        templateUrl: '/partials/forms/add-menu-to-content-group',
        controller: function($scope, $modalInstance, $log) {
          $scope.groupData = globalModel.getContentGroup(contentGroupId);
          $scope.addMenuToGroup = function(data, contentGroupId) {
            data.contentGroupId = contentGroupId;
            socket.emit('add-menu-to-content-group', data);
            return $modalInstance.dismiss('form-submit');
          };
          return $scope.cancel = function() {
            return $modalInstance.dismiss('cancel');
          };
        }
      });
    };
    return $scope.showAddPage = function(contentGroupId) {
      return $modal.open({
        templateUrl: '/partials/forms/add-page-to-content-group',
        controller: function($scope, $modalInstance, $log) {
          $scope.groupData = globalModel.getContentGroup(contentGroupId);
          $scope.addPageToGroup = function(data, contentGroupId) {
            data.contentGroupId = contentGroupId;
            socket.emit('add-page-to-content-group', data);
            return $modalInstance.dismiss('form-submit');
          };
          return $scope.cancel = function() {
            return $modalInstance.dismiss('cancel');
          };
        }
      });
    };
  });

}).call(this);
