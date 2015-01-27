(function() {
  var app;

  app = angular.module('sortByName', []);

  app.factory('sortByName', function(a, b) {
    if (a.name > b.name) {
      return 1;
    }
    if (a.name < b.name) {
      return -1;
    }
    return 0;
  });

}).call(this);
