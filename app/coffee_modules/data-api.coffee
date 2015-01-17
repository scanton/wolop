models = require '../coffee_modules/models.coffee'
getAll = (model, query, callback) ->
	if model
		model.find(
			query
			(err, data) ->
				console.log err if err
				callback data if callback
		).exec()
upsert = (model, query, data, callback) ->
	if model && data
		model.findOneAndUpdate(
			query
			{$set: data}
			{upsert: true}
			(err, rows) ->
				console.log err if err
				callback rows if callback
		)

module.exports =

	getAdmins: (callback) ->
		getAll models.Admin, {}, callback
	getContentGroups: (callback) ->
		getAll models.ContentGroup, {}, callback
	getLocales: (callback) ->
		getAll models.Locale, {}, callback
	getMenus: (callback) ->
		getAll models.Menu, {}, callback
	getPages: (callback) ->
		getAll models.Page, {}, callback
	getWebsites: (callback) ->
		getAll models.Website, {}, callback

	upsertAdmin: (data, callback) ->
		upsert models.Admin, {username: data.username}, data, callback
	upsertContentGroup: (data, callback) ->
		upsert models.ContentGroup, {slug: data.slug}, data, callback
	upsertLocale: (data, callback) ->
		upsert models.Locale, {slug: data.slug}, data, callback
	upsertMenu: (data, callback) ->
		upsert models.Menu, {slug: data.slug}, data, callback
	upsertPage: (data, callback) ->
		upsert models.Page, {slug: data.slug}, data, callback
	upsertWebsite: (data, callback) ->
		upsert models.Website, {slug: data.slug}, data, callback
