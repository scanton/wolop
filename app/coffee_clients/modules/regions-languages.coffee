socket = io()
app = angular.module 'regions-languages', []

sortByName = (a, b) ->
	if a.name > b.name
		return 1
	if a.name < b.name
		return -1
	0

app.directive 'regionsOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/regions-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.regions = globalModel.getRegions()
		socket.on 'regions-update', (data) ->
			data.map (region) ->
				if region.languages
					region.languages.sort sortByName
			$scope.$apply ->
				$scope.regions = data.sort sortByName if data

app.directive 'languagesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/languages-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.languages = globalModel.getLanguages()
		socket.on 'languages-update', (data) ->
			$scope.$apply ->
				$scope.languages = data.sort sortByName if data

app.controller 'RegionsController', ($scope, $modal, globalModel, $log) ->

	$scope.languages = globalModel.getLanguages()
	socket.on 'languages-update', (data) ->
		$scope.$apply ->
			$scope.languages = data.sort sortByName
	
	$scope.editRegion = (regionId) ->
		$scope.regionId = regionId
		$scope.regionData = globalModel.getRegion regionId
		$modal.open
			templateUrl: '/partials/forms/edit-region'
			controller: 'EditRegionController'
			scope: $scope

	$scope.addLanguage = (regionId) ->
		$scope.regionId = regionId
		$modal.open
			templateUrl: '/partials/forms/add-language-to-region'
			controller: 'AddLanguageToRegionController'
			scope: $scope

	$scope.showCreateRegion = ->
		$modal.open
			templateUrl: '/partials/forms/create-region'
			controller: 'CreateRegionController'

app.controller 'EditRegionController', ($scope, $modalInstance, globalModel, $log) ->

	$scope.updateRegion = (data) ->
		socket.emit 'update-region', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'CreateRegionController', ($scope, $modalInstance, $log) ->
	$scope.createRegion = (data) ->
		socket.emit 'create-region', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'AddLanguageToRegionController', ($scope, $modalInstance, $log) ->
	$scope.addLanguageToRegion = (regionId, languageId) ->
		socket.emit 'add-language-to-region', {regionId: regionId, languageId: languageId}
		$modalInstance.dismiss 'form-submit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

#languages
app.controller 'AddLanguageController', ($scope, $modalInstance, $log) ->
	$scope.addLanguage = (data) ->
		socket.emit 'add-language', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'LanguagesController', ($scope, $modal, $log) ->
	$scope.showCreateLanguage = ->
		$modal.open
			templateUrl: '/partials/forms/create-language'
			controller: 'CreateLanguageController'

app.controller 'CreateLanguageController', ($scope, $modalInstance, $log) ->
	$scope.createLanguage = (data) ->
		socket.emit 'create-language', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'