(function() {
  var app, socket;

  socket = io();

  app = angular.module('chat-widget', []);

  app.directive('chatWidget', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/chat-widget.html',
      controller: function($scope, $log) {
        $log.info('hit');
        $scope.peers = {};
        $scope.chatArray = [];
        $scope.sendMessage = function(message) {
          return socket.emit('chat-message', message);
        };
        socket.on('chat-message-update', function(data) {
          return $scope.$apply(function() {
            return $scope.chatArray.push(data);
          });
        });
        return socket.on('auth-users-update', function(data) {
          return $scope.$apply(function() {
            return $scope.peers = data;
          });
        });
      }
    };
  });

}).call(this);
