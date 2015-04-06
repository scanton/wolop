Template.breadcrumbs.helpers

	getOtherLanguages: ->
		reg = Session.get 'current-region'
		currentLanguage = Session.get 'current-language'
		currentRegion = Regions.findOne { slug: reg }
		if currentRegion
			otherLangs = _.without currentRegion.supportedLanguages, currentLanguage
			return Languages.find({ slug: { $in: otherLangs } }).fetch()
		return null

	getOtherRegions: ->
		reg = Session.get 'current-region'
		currentGroup = Session.get 'content-group-context'
		groupDetail = ContentGroups.findOne { slug: currentGroup }
		if groupDetail
			supportedRegions = _.without groupDetail.supportedRegions, reg
			if supportedRegions
				return Regions.find({ slug: { $in: supportedRegions } }).fetch()
		return null

	getOtherContentGroups: ->
		group = Session.get 'content-group-context'
		website = Session.get 'website-context'
		currentWebsite = Websites.findOne { slug: website }
		if currentWebsite
			supportedContentGroups = _.without currentWebsite.supportedContentGroups, group
			if supportedContentGroups
				return ContentGroups.find({ slug: { $in: supportedContentGroups } }).fetch()
		return null

	getOtherWebsites: ->
		website = Session.get 'website-context'
		Websites.find({ slug: { $not: website } }).fetch()

Template.breadcrumbs.events
	
	'click .switch-website': (e) ->
		e.preventDefault()
		Session.set 'website-context', $(e.target).attr 'data-slug'

	'click .admin-menu-toggle': (e) ->
		e.preventDefault()
		Session.set 'show-main-nav', !Session.get('show-main-nav', false)