t = Template
t.registerHelper 'formatTime', (time, type) ->
	switch type
		when 'fromNow'
			return moment.unix(time).fromNow()
		when 'iso'
			return moment.unix(time).toISOString()
		else
			return moment.unix(time).format('LLLL')

intToRGB = (i) ->
	(i >> 16 & 0xFF).toString(16) + (i >> 8 & 0xFF).toString(16) + (i & 0xFF).toString(16)
hashCode = (str) ->
	hash = 0
	i = 0
	while i < str.length
		hash = str.charCodeAt(i) + (hash << 5) - hash
		i++
	hash

t.registerHelper 'intToRGB', intToRGB
t.registerHelper 'hashCode', hashCode
t.registerHelper 'hashColor', (str) ->
	intToRGB hashCode(str)

Session.set 'delete-enabled', false
if !Session.get 'current-region'
	Session.set 'current-region', 'uk'
if !Session.get 'current-language'
	Session.set 'current-language', 'en'
if !Session.get 'admin-history-limit'
	Session.set 'admin-history-limit', 4

t.layout.helpers
	adminHistory: ->
		AdminHistory.find {}, {limit: Session.get 'admin-history-limit'}
	deleteEnabled: ->
		Session.get 'delete-enabled'
	deleteEnabledClass: ->
		if Session.get('delete-enabled') then 'delete-enabled' else 'delete-disabled'
	adminHistoryLimit: ->
		Session.get 'admin-history-limit'

t.contentGroups.helpers
	contentGroups: ->
		ContentGroups.find {}
	languages: ->
		Languages.find {}
	regions: ->
		Regions.find {}
	menus: ->
		Menus.find {}
	pages: ->
		Pages.find {}

t.editMenuDetails.helpers
	contentGroup: ->
		ContentGroups.findOne { slug: @group }
	getRegion: (region) ->
		Regions.findOne { slug: region }
	getLanguage: (language) ->
		Languages.findOne { slug: language }
	isCurrentLanguage: (lang) ->
		if Session.get('current-language') == lang
			return 'active-language'
		else
			return ''
	isCurrentRegion: (region) ->
		if Session.get('current-region') == region
			return 'active-region'
		else
			return ''

t.editPageDetails.helpers
	contentGroup: ->
		ContentGroups.findOne { slug: @group }
	getRegion: (region) ->
		Regions.findOne { slug: region }
	getLanguage: (language) ->
		Languages.findOne { slug: language }
	getPage: (pageSlug) ->
		Pages.findOne { slug: pageSlug }
	getPageDetails: (pageSlug) ->
		#PageDetails
	isCurrentLanguage: (lang) ->
		if Session.get('current-language') == lang
			return 'active-language'
		else
			return ''
	isCurrentRegion: (region) ->
		if Session.get('current-region') == region
			return 'active-region'
		else
			return ''

t.home.helpers
	websites: ->
		Websites.find {}, { sort: { name: -1 } }
	getContentGroupDetails: (slug) ->
		ContentGroups.findOne {slug: slug}
	getRiskAsBSClass: (riskLevel) ->
		if riskLevel == 'low'
			return 'btn-success'
		else if riskLevel == 'medium'
			return 'btn-warning'
		else if riskLevel == 'high'
			return 'btn-danger'
		return 'btn-default'

t.languages.helpers
	languages: ->
		Languages.find {}

t.menus.helpers
	menus: ->
		Menus.find {}

t.pages.helpers
	pages: ->
		Pages.find {}

t.regions.helpers
	languages: ->
		Languages.find {}
	regions: ->
		Regions.find {}

t.websites.helpers
	websites: ->
		Websites.find {}, { sort: { name: 1 } }
	contentGroups: ->
		ContentGroups.find {}