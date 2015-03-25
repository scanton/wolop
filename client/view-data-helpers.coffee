t = Template
helper = t.registerHelper
helper 'formatTime', (time, type) ->
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
riskBs = (riskLevel) ->
	if riskLevel == 'low'
		return 'btn-success'
	if riskLevel == 'medium'
		return 'btn-warning'
	if riskLevel == 'high'
		return 'btn-danger'
	return 'btn-default'
riskBsLabel = (riskLevel) ->
	if riskLevel == 'low'
		return 'success'
	if riskLevel == 'medium'
		return 'warning'
	if riskLevel == 'high'
		return 'danger'
	return 'default'

helper 'intToRGB', intToRGB
helper 'hashCode', hashCode
helper 'getRiskAsBsClass', riskBs
helper 'getRiskLabel', riskBsLabel
helper 'websiteContext', ->
	Websites.findOne {slug: Session.get 'website-context'}
helper 'contentGroupContext', ->
	ContentGroups.findOne {slug: Session.get 'content-group-context'}
helper 'regionContext', ->
	Regions.findOne { slug: Session.get('current-region') }
helper 'languageContext', ->
	Languages.findOne { slug: Session.get('current-language') }
helper 'hashColor', (str) ->
	intToRGB hashCode(str)
helper 'getWebsite', (slug) ->
	Websites.findOne { slug: slug }
helper 'getContentGroup', (slug) ->
	ContentGroups.findOne { slug: slug }
helper 'getRegion', (region) ->
	Regions.findOne { slug: region }
helper 'getLanguage', (language) ->
	Languages.findOne { slug: language }
helper 'getMenu', (slug) ->
	Menus.findOne { slug: slug }
helper 'getPage', (slug) ->
	Pages.findOne { slug: slug }
helper 'getPageDetails', (slug) ->
	PageDetails.findOne { parent: slug, region: Session.get('region-context'), language: Session.get('language-context') }
helper 'coworkers', ->
	Presences.find {}
helper 'isCurrentLanguage', (lang) ->
	if Session.get('current-language') == lang
		return 'active-language'
	else
		return ''
helper 'isCurrentRegion', (region) ->
	if Session.get('current-region') == region
		return 'active-region'
	else
		return ''

Session.set 'delete-enabled', false
if !Session.get 'admin-history-limit'
	Session.set 'admin-history-limit', 3

t.layout.helpers
	adminHistory: ->
		AdminHistory.find {}, { limit: Session.get 'admin-history-limit' }
	deleteEnabled: ->
		Session.get 'delete-enabled'
	deleteEnabledClass: ->
		if Session.get('delete-enabled') then 'delete-enabled' else 'delete-disabled'
	adminHistoryLimit: ->
		Session.get 'admin-history-limit'
	getUserDetails: (id) ->
		Meteor.users.findOne { _id: id }

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
	menu: ->
		Menus.findOne { slug: @menu }
	filterUsedPages: (pages) ->
		if pages
			menu = Menus.findOne { slug: @menu }
			if menu
				sp = menu.supportedPages || []
				a = []
				l = pages.length
				while l--
					page = pages[l]
					isUsed = false
					l2 = sp.length
					while l2--
						if sp[l2] == page
							isUsed = true
					if !isUsed
						a.push page
				a.sort()
				return a
	getPageName: (slug) ->
		p = Pages.findOne { slug: slug }
		if p
			return p.name
		return slug

t.editPageLocalization.helpers
	contentGroup: ->
		ContentGroups.findOne { slug: @group }
	showChecked: (val) ->
		if val == 'on'
			return 'checked'
		return ''
	getPageLocalization: (page) ->
		region = Session.get 'current-region'
		language = Session.get 'current-language'
		PageLocalizations.findOne { page: page, region: region, language: language }

t.editWebsiteContentGroup.helpers
	getRiskLabel: riskBsLabel
	website: ->
		Websites.findOne { slug: @website }
	contentGroup: ->
		ContentGroups.findOne { slug: @group }

t.home.helpers
	websites: ->
		Websites.find { isActive: 'on' }, { sort: { name: 1 } }
	contentGroups: ->
		ContentGroups.find {}, { sort: { slug: 1 } }
	regions: ->
		Regions.find {}, { sort: { name: 1 } }
	getContentGroupDetails: (slug) ->
		ContentGroups.findOne { slug: slug }
	deleteEnabled: ->
		Session.get 'delete-enabled'
	getRiskAsBsClass: riskBs

t.languages.helpers
	languages: ->
		Languages.find {}, { sort: { name: 1 } }

t.menus.helpers
	menus: ->
		Menus.find {}, { sort: { slug: 1 } }

t.pages.helpers
	pages: ->
		Pages.find {}, { sort: { name: 1 } }

t.regions.helpers
	languages: ->
		Languages.find {}, { sort: { name: 1 } }
	regions: ->
		Regions.find {}, { sort: { name: 1 } }

t.websiteDetails.helpers
	getWebsiteSlug: ->
		t.parentData(2).slug

t.websites.helpers
	websites: ->
		Websites.find {}, { sort: { name: 1 } }
	contentGroups: ->
		ContentGroups.find {}
	canReactivate: (slug) ->
		w = Websites.findOne { slug: slug }
		return w.isActive != 'on'