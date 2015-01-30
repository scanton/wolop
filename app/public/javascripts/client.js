(function() {
  var app, socket;

  socket = io();

  app = angular.module('wolop-cms', ['ngRoute', 'ui.bootstrap', 'ui.ace', 'config', 'home', 'content-groups', 'pages', 'menus', 'regions-languages', 'websites', 'users', 'navigation', 'chat', 'global-model', 'utils', 'recent-activity']);

  app.controller('CmsController', function($scope, globalModel, $log) {
    $scope.isLoggedIn = false;
    $scope.userData = {};
    $scope.newUser = {};
    $scope.currentWebsite = '';
    $scope.currentRegion = '';
    $scope.currentRegionName = '';
    $scope.currentLanguage = '';
    $scope.currentLanguageName = '';
    $scope.currentLanguages = [];
    $scope.setRegion = function(slug) {
      var region;
      region = globalModel.getRegionBySlug(slug);
      $scope.currentRegion = slug;
      $scope.currentLanguages = region.languages;
      return $scope.currentRegionName = region.name;
    };
    $scope.setLanguage = function(slug) {
      var lang;
      lang = globalModel.getLanguageBySlug(slug);
      $scope.currentLanguage = slug;
      return $scope.currentLanguageName = lang.name;
    };
    $scope.setWebsite = function(slug) {
      return $scope.currentWebsite = slug;
    };
    return socket.on('login-success', function(data) {
      return $scope.$apply(function() {
        $scope.userData = data;
        return $scope.isLoggedIn = true;
      });
    });
  });

}).call(this);
