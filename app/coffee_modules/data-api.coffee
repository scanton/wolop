models = require '../coffee_modules/models.coffee'
getAll = (model, query, callback) ->
	if model
		model.find(
			query
			(err, data) ->
				console.log err if err
				callback data if callback
		)
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
		models.Website.update {slug: site}, data, null, callback

	updateRegionLanguages: (regionId, data, callback) ->
		models.Region.update {_id: regionId}, data, null, callback

	getWebsite: (query, callback) ->
		getOne models.Website, query, callback
	getRegion: (query, callback) ->
		getOne models.Region, query, callback

	getAdmins: (callback) ->
		getAll models.Admin, {}, callback
	getContentGroups: (callback) ->
		getAll models.ContentGroup, {}, callback
	getRegions: (callback) ->
		models.Region.find {}
			.populate 'languages'
			.exec (err, rows) ->
				console.log err if err
				callback rows if callback

	getLanguages: (callback) ->
		getAll models.Language, {}, callback
	getMenus: (callback) ->
		getAll models.Menu, {}, callback
	getPages: (callback) ->
		getAll models.Page, {}, callback
	getWebsites: (callback) ->
		models.Website.find {}
			.populate 'contentGroups'
			.populate 'regions'
			.exec (err, rows) ->
				console.log err if err
				callback rows if callback

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
