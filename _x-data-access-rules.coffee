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
				console.log 'Insert Language Failed: slug must be unique' if result
				return !result
			return false
		update: adminOnly
	Regions.allow
		insert: (userId, doc) ->
			if userId and doc.slug and Meteor.user().roles.admin
				result = Regions.findOne { slug: doc.slug }
				console.log 'Insert Region Failed: slug must be unique' if result
				return !result
			return false
		update: adminOnly
	Websites.allow
		insert: (userId, doc) ->
			if userId and doc.slug and Meteor.user().roles.admin
				result = Websites.findOne { slug: doc.slug }
				console.log 'Insert Website Failed: slug must be unique' if result
				return !result
			return false
		update: adminOnly
	ContentGroups.allow
		insert: (userId, doc) ->
			if userId and doc.slug and Meteor.user().roles.admin
				result = ContentGroups.findOne { slug: doc.slug }
				console.log 'Insert Content Group Failed: slug must be unique' if result
				return !result
			return false
		update: adminOnly
	Pages.allow
		insert: (userId, doc) ->
			if userId and doc.slug and Meteor.user().roles.admin
				result = Pages.findOne { slug: doc.slug }
				console.log 'Insert Page Failed: slug must be unique' if result
				return !result
			return false
		update: adminOnly
	PageLocalizations.allow
		insert: (userId, doc) ->
			userId and doc.region and doc.language and doc.title
		update: adminOnly
	Menus.allow
		insert: (userId, doc) ->
			if userId and doc.slug and Meteor.user().roles.admin
				result = Menus.findOne { slug: doc.slug }
				console.log 'Insert Menu Failed: slug must be unique' if result
				return !result
			return false
		update: adminOnly
	AdminHistory.allow
		insert: allowAll
		update: allowAll
