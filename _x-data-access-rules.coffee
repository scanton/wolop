if Meteor.isServer

	adminOnly = (userId, doc, fields, modifier) ->
		Meteor.user().roles.admin

	nameSlugRequired = (userId, doc) ->
		userId and doc.name and doc.slug and Meteor.user().roles.admin

	allowAll = (userId, doc) ->
		true

	Languages.allow
		insert: (userId, doc) ->
			if userId and doc.slug and Meteor.user().roles.admin
				result = Languages.findOne { slug: doc.slug }
				console.log 'Insert Failed: slug must be unique' if result
				return !result
			return false
		update: adminOnly
	Regions.allow
		insert: nameSlugRequired
		update: adminOnly
	Websites.allow
		insert: nameSlugRequired
		update: adminOnly
	ContentGroups.allow
		insert: nameSlugRequired
		update: adminOnly
	Pages.allow
		insert: nameSlugRequired
		update: adminOnly
	PageLocalizations.allow
		insert: (userId, doc) ->
			userId and doc.region and doc.language and doc.title
		update: adminOnly
	Menus.allow
		insert: nameSlugRequired
		update: adminOnly
	AdminHistory.allow
		insert: allowAll
		update: allowAll
