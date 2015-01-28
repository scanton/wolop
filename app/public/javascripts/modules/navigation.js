(function() {
  var app, socket;

  socket = io();

  app = angular.module('navigation', []);

  app.directive('navBar', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/nav-bar.html',
      controller: function($scope, $location, $log) {
        $scope.path = $location.path();
        $scope.$on('$locationChangeStart', function(event, next, current) {
          return $scope.path = next.split('#')[1];
        });
        return $scope.navData = [
          {
            label: 'Websites',
            link: '/websites'
          }, {
            label: 'Products',
            link: '/products'
          }, {
            label: 'Content Groups',
            link: '/content-groups'
          }, {
            label: 'Regions',
            link: '/regions'
          }, {
            label: 'Languages',
            link: '/languages'
          }, {
            label: 'Static Text',
            link: '/static-text'
          }, {
            label: 'Users',
            link: '/users'
          }, {
            label: 'Notices',
            link: '/notices'
          }
        ];
      }
    };
  });

}).call(this);
