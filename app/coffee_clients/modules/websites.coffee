socket = io()
app = angular.module 'websites', []

app.directive 'websitesOverview', (sortByName) ->
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

app.controller 'WebsitesController', ($scope, $modal, globalModel, sortByName, $log) ->
	
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
			scope: $scope
			controller: ($scope, $modalInstance, $log) ->
				$scope.addContentGroup = (site, contentGroupId) ->
					socket.emit 'add-content-group', {website: site, contentGroupId: contentGroupId}
					$modalInstance.dismiss 'form-sumbit'
				$scope.cancel = ->
					$modalInstance.dismiss 'cancel'
	$scope.addRegion = (slug, regionId) ->
		$scope.addRegionData = 
			website: slug
			regionId: regionId
		$modal.open
			templateUrl: '/partials/forms/add-region'
			scope: $scope
			controller: ($scope, $modalInstance, $log) ->
				$scope.addRegion = (site, regionId) ->
					socket.emit 'add-region', {website: site, regionId: regionId}
					$modalInstance.dismiss 'form-sumbit'
				$scope.cancel = ->
					$modalInstance.dismiss 'cancel'
	$scope.showCreateWebsite = ->
		$modal.open
			templateUrl: '/partials/forms/create-website'
			controller: ($scope, $modalInstance, $log) ->
				$scope.createWebsite = (data) ->
					socket.emit 'create-website', data
					$modalInstance.dismiss 'form-sumbit'
				$scope.cancel = ->
					$modalInstance.dismiss 'cancel'

app.controller 'WebsiteDetailsController', ($scope, $routeParams, $log) ->
	index = $routeParams.slug
	$scope.index = index
	socket.emit 'working-on', index

app.controller 'WebsiteContentGroupDetailsController', ($scope, $routeParams, $modal, globalModel, $log) ->
	$scope.site = globalModel.getWebsiteBySlug $routeParams.site
	$scope.group = globalModel.getContentGroupBySlug $routeParams.group
	if $scope.site && $scope.site.slug && $scope.group && $scope.group.slug
		socket.emit 'working-on', $scope.site.slug + ' (' + $scope.group.slug + ')'
	$scope.params = $routeParams
	$scope.showAddMenu = (contentGroupId) ->
		$modal.open
			templateUrl: '/partials/forms/add-menu-to-content-group'
			controller: ($scope, $modalInstance, $log) ->
				$scope.groupData = globalModel.getContentGroup contentGroupId
				$scope.addMenuToGroup = (data, contentGroupId) ->
					data.contentGroupId = contentGroupId
					socket.emit 'add-menu-to-content-group', data
					$modalInstance.dismiss 'form-submit'
				$scope.cancel = ->
					$modalInstance.dismiss 'cancel'
	$scope.showAddPage = (contentGroupId) ->
		$modal.open
			templateUrl: '/partials/forms/add-page-to-content-group'
			controller: ($scope, $modalInstance, $log) ->
				$scope.groupData = globalModel.getContentGroup contentGroupId
				$scope.addPageToGroup = (data, contentGroupId) ->
					data.contentGroupId = contentGroupId
					socket.emit 'add-page-to-content-group', data
					$modalInstance.dismiss 'form-submit'
				$scope.cancel = ->
					$modalInstance.dismiss 'cancel'

