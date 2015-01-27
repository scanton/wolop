(function() {
  var app, socket, sortByName;

  socket = io();

  app = angular.module('websites', []);

  sortByName = function(a, b) {
    if (a.name > b.name) {
      return 1;
    }
    if (a.name < b.name) {
      return -1;
    }
    return 0;
  };

  app.directive('websitesOverview', function() {
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

  app.controller('WebsitesController', function($scope, $modal, globalModel, $log) {
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
        controller: 'AddContentGroupController',
        scope: $scope
      });
    };
    $scope.addRegion = function(slug, regionId) {
      $scope.addRegionData = {
        website: slug,
        regionId: regionId
      };
      return $modal.open({
        templateUrl: '/partials/forms/add-region',
        controller: 'AddRegionController',
        scope: $scope
      });
    };
    return $scope.showCreateWebsite = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-website',
        controller: 'CreateWebsiteController'
      });
    };
  });

  app.controller('AddContentGroupController', function($scope, $modalInstance, $log) {
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
  });

  app.controller('AddRegionController', function($scope, $modalInstance, $log) {
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
  });

  app.controller('CreateWebsiteController', function($scope, $modalInstance, $log) {
    $scope.createWebsite = function(data) {
      socket.emit('create-website', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('WebsiteDetailsController', function($scope, $routeParams, $log) {
    var index;
    index = $routeParams.slug;
    $scope.index = index;
    return socket.emit('working-on', index);
  });

  app.controller('WebsiteContentGroupDetailsController', function($scope, $routeParams, $log) {
    var group, site;
    site = $routeParams.site;
    group = $routeParams.group;
    socket.emit('working-on', site + ' (' + group + ')');
    return $scope.params = $routeParams;
  });

}).call(this);
