socket = io()
app = angular.module 'chat', []

app.directive 'chatWidget', ->
	restrict: 'E'
	templateUrl: '/partials/directives/chat-widget.html'
	controller: ($scope, $log) ->
		$scope.peers = {}
		$scope.chatArray = []
		$scope.chatMessage = ''
		$scope.sendMessage = () ->
			socket.emit 'chat-message', $scope.chatMessage
			$scope.chatMessage = ''
		socket.on 'chat-message-update', (data) ->
			$scope.$apply ->
				$scope.chatArray.push data
		socket.on 'auth-users-update', (data) ->
			$scope.$apply ->
				$scope.peers = data