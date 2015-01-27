socket = io()
app = angular.module 'websites', []

sortByName = (a, b) ->
	if a.name > b.name
		return 1
	if a.name < b.name
		return -1
	0

app.directive 'websitesOverview', ->
	restrict: 'E'
	templateUrl: '/partials/directives/websites-overview.html'
	controller: ($scope, globalModel, $log) ->
		$scope.websites = globalModel.getWebsites()
		socket.on 'websites-update', (data) ->
			$scope.$apply ->
				data.map (site) ->
					site.contentGroups.sort sortByName if site.contentGroups
					site.regions.sort sortByName if site.regions
				$scope.websites = data.sort sortByName if data

app.controller 'WebsitesController', ($scope, $modal, globalModel, $log) ->
	
	$scope.contentGroups = globalModel.getContentGroups()
	socket.on 'content-groups-update', (data) ->
		$scope.$apply ->
			$scope.contentGroups = data.sort sortByName

	$scope.regions = globalModel.getRegions()
	socket.on 'regions-update', (data) ->
		data.map (region) ->
			if region.languages
				region.languages.sort sortByName
		$scope.$apply ->
			$scope.regions = data.sort sortByName

	$scope.addContentGroup = (slug) ->
		$scope.addContentGroupData = 
			website: slug
		$modal.open
			templateUrl: '/partials/forms/add-content-group'
			controller: 'AddContentGroupController'
			scope: $scope
	$scope.addRegion = (slug, regionId) ->
		$scope.addRegionData = 
			website: slug
			regionId: regionId
		$modal.open
			templateUrl: '/partials/forms/add-region'
			controller: 'AddRegionController'
			scope: $scope
	$scope.showCreateWebsite = ->
		$modal.open
			templateUrl: '/partials/forms/create-website'
			controller: 'CreateWebsiteController'

app.controller 'AddContentGroupController', ($scope, $modalInstance, $log) ->
	$scope.addContentGroup = (site, contentGroupId) ->
		socket.emit 'add-content-group', {website: site, contentGroupId: contentGroupId}
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'
		
app.controller 'AddRegionController', ($scope, $modalInstance, $log) ->
	$scope.addRegion = (site, regionId) ->
		socket.emit 'add-region', {website: site, regionId: regionId}
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'CreateWebsiteController', ($scope, $modalInstance, $log) ->
	$scope.createWebsite = (data) ->
		socket.emit 'create-website', data
		$modalInstance.dismiss 'form-sumbit'
	$scope.cancel = ->
		$modalInstance.dismiss 'cancel'

app.controller 'WebsiteDetailsController', ($scope, $routeParams, $log) ->
	index = $routeParams.slug
	$scope.index = index
	socket.emit 'working-on', index

app.controller 'WebsiteContentGroupDetailsController', ($scope, $routeParams, $log) ->
	site = $routeParams.site
	group = $routeParams.group
	socket.emit 'working-on', site + ' (' + group + ')'
	$scope.params = $routeParams
