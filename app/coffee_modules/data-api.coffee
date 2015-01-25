models = require '../coffee_modules/models.coffee'
getAll = (model, query, callback) ->
	if model
		model.find(
			query
			(err, data) ->
				console.log err if err
				callback data if callback
		).exec()
getOne = (model, query, callback) ->
	if model
		model.findOne(
			query
			(err, data) ->
				console.log err if err
				callback data if callback
		)
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
	updateWebsiteContentGroups: (site, data, callback) ->
		models.Website.update {slug: site}, data, null, callback
	updateWebsiteRegions: (site, data, callback) ->
		console.log data
		models.Website.update {slug: site}, data, null, callback

	getWebsite: (query, callback) ->
		getOne models.Website, query, callback
		
	getAdmins: (callback) ->
		getAll models.Admin, {}, callback
	getContentGroups: (callback) ->
		getAll models.ContentGroup, {}, callback
	getRegions: (callback) ->
		getAll models.Region, {}, callback
	getLanguages: (callback) ->
		getAll models.Language, {}, callback
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
	upsertRegion: (data, callback) ->
		upsert models.Region, {slug: data.slug}, data, callback
	upsertLanguage: (data, callback) ->
		upsert models.Language, {slug: data.slug}, data, callback
	upsertMenu: (data, callback) ->
		upsert models.Menu, {slug: data.slug}, data, callback
	upsertPage: (data, callback) ->
		upsert models.Page, {slug: data.slug}, data, callback
	upsertWebsite: (data, callback) ->
		upsert models.Website, {slug: data.slug}, data, callback
