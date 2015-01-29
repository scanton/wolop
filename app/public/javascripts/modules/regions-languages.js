(function() {
  var app, socket;

  socket = io();

  app = angular.module('regions-languages', []);

  app.directive('regionsOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/regions-overview.html',
      controller: function($scope, globalModel, sortByName, $log) {
        $scope.regions = globalModel.getRegions();
        return socket.on('regions-update', function(data) {
          data.map(function(region) {
            if (region.languages) {
              return region.languages.sort(sortByName);
            }
          });
          return $scope.$apply(function() {
            if (data) {
              return $scope.regions = data.sort(sortByName);
            }
          });
        });
      }
    };
  });

  app.directive('languagesOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/languages-overview.html',
      controller: function($scope, globalModel, sortByName, $log) {
        $scope.languages = globalModel.getLanguages();
        return socket.on('languages-update', function(data) {
          return $scope.$apply(function() {
            if (data) {
              return $scope.languages = data.sort(sortByName);
            }
          });
        });
      }
    };
  });

  app.controller('RegionsController', function($scope, $modal, globalModel, sortByName, $log) {
    $scope.languages = globalModel.getLanguages();
    socket.on('languages-update', function(data) {
      return $scope.$apply(function() {
        return $scope.languages = data.sort(sortByName);
      });
    });
    $scope.editRegion = function(regionId) {
      $scope.regionId = regionId;
      $scope.regionData = globalModel.getRegion(regionId);
      return $modal.open({
        templateUrl: '/partials/forms/edit-region',
        controller: 'EditRegionController',
        scope: $scope
      });
    };
    $scope.addLanguage = function(regionId) {
      $scope.regionId = regionId;
      return $modal.open({
        templateUrl: '/partials/forms/add-language-to-region',
        controller: 'AddLanguageToRegionController',
        scope: $scope
      });
    };
    return $scope.showCreateRegion = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-region',
        controller: 'CreateRegionController'
      });
    };
  });

  app.controller('EditRegionController', function($scope, $modalInstance, globalModel, $log) {
    $scope.updateRegion = function(data) {
      socket.emit('update-region', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('CreateRegionController', function($scope, $modalInstance, $log) {
    $scope.createRegion = function(data) {
      socket.emit('create-region', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('AddLanguageToRegionController', function($scope, $modalInstance, $log) {
    $scope.addLanguageToRegion = function(regionId, languageId) {
      socket.emit('add-language-to-region', {
        regionId: regionId,
        languageId: languageId
      });
      return $modalInstance.dismiss('form-submit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('AddLanguageController', function($scope, $modalInstance, $log) {
    $scope.addLanguage = function(data) {
      socket.emit('add-language', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('LanguagesController', function($scope, $modal, $log) {
    return $scope.showCreateLanguage = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-language',
        controller: 'CreateLanguageController'
      });
    };
  });

  app.controller('CreateLanguageController', function($scope, $modalInstance, $log) {
    $scope.createLanguage = function(data) {
      socket.emit('create-language', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

}).call(this);
