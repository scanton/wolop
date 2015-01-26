(function() {
  var app, socket;

  socket = io();

  app = angular.module('chat', []);

  app.directive('chatWidget', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/chat-widget.html',
      controller: function($scope, $log) {
        $scope.peers = {};
        $scope.chatArray = [];
        $scope.chatMessage = '';
        $scope.sendMessage = function() {
          socket.emit('chat-message', $scope.chatMessage);
          return $scope.chatMessage = '';
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
