(function() {
  var app;

  app = angular.module('utils', []);

  app.factory('sortByName', function() {
    return function(a, b) {
      if (a.name > b.name) {
        return 1;
      }
      if (a.name < b.name) {
        return -1;
      }
      return 0;
    };
  });

}).call(this);
