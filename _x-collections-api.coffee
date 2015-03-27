actionLogger = (description, query, options, data) ->
	o = 
		userId: Meteor.userId()
		user: Meteor.user().profile.name
		description: description
		data: JSON.stringify(data)
		query: JSON.stringify(query)
		options: JSON.stringify(options)
		created: new Date
	AdminHistory.insert o

fixIsActiveBoolean = (data) ->
	if data && data.isActive == 1
		data.isActive = 'on'
	return data

preprocessData = (data) ->
	if data
		data = fixIsActiveBoolean data
		data.supportedMenus.sort() if data.supportedMenus
		data.supportedPages.sort() if data.supportedPages
		data.supportedRegions.sort() if data.supportedRegions
		data.supportedLanguages.sort() if data.supportedLanguages
		data.supportedContentGroups.sort() if data.supportedContentGroups
		data.supportedWebsites.sort() if data.supportedWebsites
	return data

updateRegion = (query, options) ->
	data = preprocessData data
	actionLogger 'Regions.update', query, options, Regions.update(query, options)

updateLanguage = (query, options) ->
	data = preprocessData data
	actionLogger 'Languages.update', query, options, Languages.update(query, options)

updateWebsite = (query, options) ->
	console.log data
	data = preprocessData data
	console.log data
	actionLogger 'Websites.update', query, options, Websites.update(query, options)

updateContentGroup = (query, options) ->
	data = preprocessData data
	actionLogger 'ContentGroups.update', query, options, ContentGroups.update(query, options)

updatePage = (query, options) ->
	data = preprocessData data
	actionLogger 'Pages.update', query, options, Pages.update(query, options)

updatePageLocalization = (query, options) ->
	data = preprocessData data
	actionLogger 'PageLocalizations.update', query, options, PageLocalizations.update(query, options)

updateMenu = (query, options) ->
	data = preprocessData data
	actionLogger 'Menus.update', query, options, Menus.update(query, options)

insertRegion = (data) ->
	data = preprocessData data
	actionLogger 'Regions.insert', '', data, Regions.insert(data)

insertLanguage = (data) ->
	data = preprocessData data
	actionLogger 'Language.insert', '', data, Languages.insert(data)

insertWebsite = (data) ->
	data = preprocessData data
	actionLogger 'Websites.insert', '', data, Websites.insert(data)

insertContentGroup = (data) ->
	data = preprocessData data
	actionLogger 'ContentGroups.insert', '', data, ContentGroups.insert(data)

insertPage = (data) ->
	data = preprocessData data
	actionLogger 'Pages.insert', '', data, Pages.insert(data)

insertPageLocalization = (data) ->
	data = preprocessData data
	actionLogger 'PageLocalizations.insert', '', data, PageLocalizations.insert(data)

insertMenu = (data) ->
	data = preprocessData data
	actionLogger 'Menus.insert', '', data, Menus.insert(data)

defineCollectionApi

	logAction: actionLogger

	insertWebsite: insertWebsite
	insertContentGroup: insertContentGroup
	insertRegion: insertRegion
	insertLanguage: insertLanguage
	insertMenu: insertMenu
	insertPage: insertPage
	insertPageLocalization: insertPageLocalization

	getWebsite: (slug) ->
		Websites.findOne {slug: slug}
	getContentGroup: (slug) ->
		ContentGroups.findOne {slug: slug}
	getRegion: (slug) ->
		Regions.findOne {slug: slug}
	getLanguage: (slug) ->
		Languages.findOne {slug: slug}
	getMenu: (slug) ->
		Menus.findOne {slug: slug}
	getPage: (slug) ->
		Pages.findOne {slug: slug}

	updateWebsite: updateWebsite
	updateContentGroup: updateContentGroup
	updateRegion: updateRegion
	updateLanguage: updateLanguage
	updateMenu: updateMenu
	updatePage: updatePage
	updatePageLocalization: updatePageLocalization

	movePageUpOnMenu: (page, menu) ->
		if page and menu
			m = Menus.findOne {slug: menu}
			sp = m.supportedPages or []
			l = sp.length
			while l--
				if sp[l] == page
					index = l
					break
			if index and index > 0
				x = sp.splice(index, 1)
				sp.splice index - 1, 0, x[0]
			updateMenu { _id: m._id }, $set: supportedPages: sp

	movePageDownOnMenu: (page, menu) ->
		if page and menu
			m = Menus.findOne {slug: menu}
			sp = m.supportedPages or []
			l = sp.length
			while l--
				if sp[l] == page
					index = l
					break
			if index < sp.length - 1
				x = sp.splice(index, 1)
				sp.splice index + 1, 0, x[0]
			updateMenu { _id: m._id }, $set: supportedPages: sp

	addPageToMenu: (page, menu) ->
		if page and menu
			m = Menus.findOne {slug: menu}
			sp = m.supportedPages or []
			l = sp.length
			while l--
				if sp[l] == page
					return
			if !sp
				sp = []
			sp.unshift page
			updateMenu { _id: m._id }, $set: supportedPages: sp

	removePageFromMenu: (page, menu) ->
		if page and menu
			m = Menus.findOne {slug: menu}
			sp = m.supportedPages or []
			l = sp.length
			while l--
				if sp[l] == page
					sp.splice l, 1
			updateMenu { _id: m._id }, $set: supportedPages: sp

	updatePageDetails: (data) ->
		if data and data.page and data.title and data.region and data.language
			pageDetail = PageLocalizations.findOne
				page: data.page
				region: data.region
				language: data.language
			if pageDetail and pageDetail._id
				data.modified = new Date
				actionLogger 'PageLocalizations.update', '', data, PageLocalizations.update({ _id: pageDetail._id }, $set: data)
			else
				data.modified = data.created = new Date
				actionLogger 'PageLocalizations.insert', '', data, PageLocalizations.insert(data)
		else
			console.log 'invalid Page Details, _global.updatePageDetails'

	deactivateWebsite: (slug) ->
		if slug
			id = Websites.findOne(slug: slug)._id
			if id
				actionLogger 'Website Deactivated', { _id: id }, slug
				Websites.update { _id: id }, $set: isActive: ''

	reactivateWebsite: (slug) ->
		if slug
			id = Websites.findOne(slug: slug)._id
			if id
				actionLogger 'Website Activated', { _id: id }, slug
				Websites.update { _id: id }, $set: isActive: 'on'

	addRegionToContentGroup: (region, group) ->
		g = ContentGroups.findOne(slug: group)
		if g
			if !g.supportedRegions
				g.supportedRegions = [ region ]
			else
				l = g.supportedRegions.length
				while l--
					if g.supportedRegions[l] == region
						return
				g.supportedRegions.push region
			g.supportedRegions.sort()
			query = _id: g._id
			options = $set: supportedRegions: g.supportedRegions
			return updateContentGroup(query, options)

	removeRegionFromContentGroup: (region, group) ->
		g = ContentGroups.findOne(slug: group)
		if g and g.supportedRegions
			l = g.supportedRegions.length
			while l--
				if g.supportedRegions[l] == region
					g.supportedRegions.splice l, 1
			query = _id: g._id
			options = $set: supportedRegions: g.supportedRegions
			return updateContentGroup(query, options)

	addLanguageToRegion: (region, language) ->
		l = undefined
		options = undefined
		query = undefined
		r = undefined
		r = Regions.findOne(slug: region)
		if r
			if !r.supportedLanguages
				r.supportedLanguages = [ language ]
			else
				l = r.supportedLanguages.length
				while l--
					if r.supportedLanguages[l] == language
						return
				r.supportedLanguages.push language
			r.supportedLanguages.sort()
			query = _id: r._id
			options = $set: supportedLanguages: r.supportedLanguages
			return updateRegion(query, options)

	removeLanguageFromRegion: (region, language) ->
		l = undefined
		options = undefined
		query = undefined
		r = undefined
		r = Regions.findOne(slug: region)
		if r and r.supportedLanguages
			l = r.supportedLanguages.length
			while l--
				if r.supportedLanguages[l] == language
					r.supportedLanguages.splice l, 1
			query = _id: r._id
			options = $set: supportedLanguages: r.supportedLanguages
			return updateRegion(query, options)

	addContentGroupToWebsite: (group, website) ->
		w = Websites.findOne(slug: website)
		if w
			if !w.supportedContentGroups
				w.supportedContentGroups = [ group ]
			else
				l = w.supportedContentGroups.length
				while l--
					if w.supportedContentGroups[l] == group
						return
				w.supportedContentGroups.push group
			w.supportedContentGroups.sort()
			query = _id: w._id
			options = $set: supportedContentGroups: w.supportedContentGroups
			return updateWebsite(query, options)

	removeContentGroupFromWebsite: (group, website) ->
		w = Websites.findOne(slug: website)
		if w and w.supportedContentGroups
			l = w.supportedContentGroups.length
			while l--
				if w.supportedContentGroups[l] == group
					w.supportedContentGroups.splice l, 1
			query = _id: w._id
			options = $set: supportedContentGroups: w.supportedContentGroups
			return updateWebsite(query, options)

	addMenuToContentGroup: (menu, group) ->
		g = ContentGroups.findOne(slug: group)
		if g
			if !g.supportedMenus
				g.supportedMenus = [ menu ]
			else
				l = g.supportedMenus.length
				while l--
					if g.supportedMenus[l] == menu
						return
				g.supportedMenus.push menu
			g.supportedMenus.sort()
			query = _id: g._id
			options = $set: supportedMenus: g.supportedMenus
			return updateContentGroup(query, options)

	removeMenuFromContentGroup: (menu, group) ->
		g = ContentGroups.findOne(slug: group)
		if g and g.supportedMenus
			l = g.supportedMenus.length
			while l--
				if g.supportedMenus[l] == menu
					g.supportedMenus.splice l, 1
			query = _id: g._id
			options = $set: supportedMenus: g.supportedMenus
			return updateContentGroup(query, options)

	addPageToContentGroup: (page, group) ->
		g = ContentGroups.findOne(slug: group)
		if g
			if !g.supportedPages
				g.supportedPages = [ page ]
			else
				l = g.supportedPages.length
				while l--
					if g.supportedPages[l] == page
						return
				g.supportedPages.push page
			g.supportedPages.sort()
			query = _id: g._id
			options = $set: supportedPages: g.supportedPages
			return updateContentGroup(query, options)

	removePageFromContentGroup: (page, group) ->
		g = ContentGroups.findOne(slug: group)
		if g and g.supportedPages
			l = g.supportedPages.length
			while l--
				if g.supportedPages[l] == page
					g.supportedPages.splice l, 1
			query = _id: g._id
			options = $set: supportedPages: g.supportedPages
			return updateContentGroup(query, options)