Template.breadcrumbs.helpers

	getOtherLanguages: ->
		reg = Session.get 'current-region'
		currentLanguage = Session.get 'current-language'
		currentRegion = Regions.findOne { slug: reg }
		if currentRegion
			otherLangs = _.without currentRegion.supportedLanguages, currentLanguage
			return Languages.find({ slug: { $in: otherLangs } }).fetch()
		return null

Template.breadcrumbs.events
	'click .admin-menu-toggle': (e) ->
		e.preventDefault()
		Session.set 'show-main-nav', !Session.get('show-main-nav', false)