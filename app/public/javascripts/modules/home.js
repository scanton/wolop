(function() {
  var app, socket;

  socket = io();

  app = angular.module('home', []);

  app.controller('HomeController', function($scope, $modal, $log) {
    return $scope.site = 'wolop';
  });

}).call(this);
