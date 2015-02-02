socket = io()
app = angular.module 'global-model', []

app.factory 'globalModel', (sortByName) ->
	model = 
		websites: []
		contentGroups: []
		regions: []
		languages: []
		menus: []
		pages: []
		users: []
		peers: []
		messages: []

	getFromSlug = (arr, slug) ->
		l = arr.length
		while l--
			if arr[l].slug == slug
				return arr[l]
	getFromId = (arr, id) ->
		l = arr.length
		while l--
			if arr[l]._id == id
				return arr[l]

	socket.on 'websites-update', (data) -> 
		data.map (site)->
			site.contentGroups.sort sortByName if site.contentGroups
			site.regions.sort sortByName if site.regions
		model.websites = data.sort sortByName if data
	socket.on 'content-groups-update', (data) -> 
		model.contentGroups = data.sort sortByName
	socket.on 'regions-update', (data) -> 
		data.map (region) ->
			region.languages.sort sortByName if region.languages
		model.regions = data.sort sortByName if data
	socket.on 'languages-update', (data) -> 
		model.languages = data.sort sortByName if data
	socket.on 'menus-update', (data) -> 
		model.menus = data.sort sortByName if data
	socket.on 'pages-update', (data) -> 
		model.pages = data.sort sortByName if data
	socket.on 'users-update', (data) -> 
		model.users = data

	getRecentActivity: ->
		[{name: 'test', slug: 'test'}]
		
	getWebsite: (id) ->
		getFromId model.websites, id
	getWebsiteBySlug: (slug) ->
		getFromSlug model.websites, slug
	getContentGroup: (id) ->
		getFromId model.contentGroups, id
	getContentGroupBySlug: (slug) ->
		getFromSlug model.contentGroups, slug
	getRegion: (id) ->
		getFromId model.regions, id
	getRegionBySlug: (slug) ->
		getFromSlug model.regions, slug
	getLanguage: (id) ->
		getFromId model.languages, id
	getLanguageBySlug: (slug) ->
		getFromSlug model.languages, slug
	getMenu: (id) ->
		getFromId model.menus, id
	getMenuBySlug: (slug) ->
		getFromSlug model.menus, slug
	getPage: (id) ->
		getFromId model.pages, id
	getPageBySlug: (slug) ->
		console.log model.pages
		getFromSlug model.pages, slug
	getUsers: -> model.users
	getWebsites: -> model.websites
	getContentGroups: -> model.contentGroups
	getRegions: -> model.regions
	getLanguages: -> model.languages
	getMenus: -> model.menus
	getPages: -> model.pages
