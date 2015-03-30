Template.pushManager.helpers

	getRiskLabel: __coffeescriptShare.riskBsLabel

	website: ->
		Websites.findOne { slug: @website }

	contentGroup: ->
		ContentGroups.findOne { slug: @group }

	menus: ->
		Menus.find {}

	pages: ->
		Pages.find {}

	groupOptions: ->
		website = Template.parentData(2).website
		site = Websites.findOne { slug: website }
		if site
			a = []
			keys = _.without site.supportedContentGroups, Template.parentData(2).group
			for k in keys
				a.push ContentGroups.findOne({ slug: k })
			return a
		else
			return null

