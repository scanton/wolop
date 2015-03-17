ContentGroups = new Mongo.Collection('content_groups');
Languages = new Mongo.Collection('languages');
Menus = new Mongo.Collection('menus');
Notices = new Mongo.Collection('notices');
Pages = new Mongo.Collection('pages');
PageDetails = new Mongo.Collection('page_details');
Products = new Mongo.Collection('products');
Regions = new Mongo.Collection('regions');
StaticText = new Mongo.Collection('static_text');
Websites = new Mongo.Collection('websites');
AdminHistory = new Mongo.Collection('admin_history');

var actionLogger = function(description, query, options, data) {
	var data = {
		userId: Meteor.userId(),
		user: Meteor.user().profile.name,
		description: description,
		data: JSON.stringify(data),
		query: JSON.stringify(query),
		options: JSON.stringify(options),
		created: new Date()
	}
	return AdminHistory.insert(data);
};
var updateRegion = function(query, options) {
	actionLogger(
		'Regions.update', 
		query, 
		options, 
		Regions.update(query, options)
	);
};
var updateLanguage = function(query, options) {
	actionLogger(
		'Languages.update', 
		query, 
		options, 
		Languages.update(query, options)
	);
};
var updateWebsite = function(query, options) {
	actionLogger(
		'Websites.update', 
		query, 
		options, 
		Websites.update(query, options)
	);
};
var updateContentGroup = function(query, options) {
	actionLogger(
		'ContentGroups.update', 
		query, 
		options, 
		ContentGroups.update(query, options)
	);
};
var updatePage = function(query, options) {
	actionLogger(
		'Pages.update', 
		query, 
		options, 
		Pages.update(query, options)
	);
};
var updatePageDetail = function(query, options) {
	actionLogger(
		'PageDetails.update', 
		query, 
		options, 
		PageDetails.update(query, options)
	);
};
var updateMenu = function(query, options) {
	actionLogger(
		'Menus.update', 
		query, 
		options, 
		Menus.update(query, options)
	);
};
var insertRegion = function(data) {
	actionLogger(
		'Regions.insert',
		'',
		data,
		Regions.insert(data)
	);
};
var insertLanguage = function(data) {
	actionLogger(
		'Language.insert',
		'',
		data,
		Language.insert(data)
	);
};
var insertWebsite = function(data) {
	actionLogger(
		'Websites.insert',
		'',
		data,
		Websites.insert(data)
	);
};
var insertContentGroup = function(data) {
	actionLogger(
		'ContentGroups.insert',
		'',
		data,
		ContentGroups.insert(data)
	);
};
var insertPage = function(data) {
	actionLogger(
		'Pages.insert',
		'',
		data,
		Pages.insert(data)
	);
};
var insertPageDetail = function(data) {
	actionLogger(
		'PageDetails.insert',
		'',
		data,
		PageDetails.insert(data)
	);
};
var insertMenu = function(data) {
	actionLogger(
		'Menus.insert',
		'',
		data,
		Menus.insert(data)
	);
};

collections = {
	logAction: actionLogger,
	updateWebsite: updateWebsite,
	updateContentGroup: updateContentGroup,
	updateRegion: updateRegion,
	updateLanguage: updateLanguage,
	updateMenu: updateMenu,
	updatePage: updatePage,
	updatePageDetail: updatePageDetail,
	insertWebsite: insertWebsite,
	insertContentGroup: insertContentGroup,
	insertRegion: insertRegion,
	insertLanguage: insertLanguage,
	insertMenu: insertMenu,
	insertPage: insertPage,
	insertPageDetail: insertPageDetail,
	addRegionToContentGroup: function(region, group) {
		var g = ContentGroups.findOne({slug: group});
		if(g) {
			if(!g.supportedRegions) {
				g.supportedRegions = [region];
			} else {
				l = g.supportedRegions.length;
				while(l--) {
					if(g.supportedRegions[l] === region) {
						return;
					}
				}
				g.supportedRegions.push(region);
			}
			g.supportedRegions.sort();
			var query = { _id: g._id };
			var options = { $set: { supportedRegions: g.supportedRegions }};
			return updateContentGroup(query, options);
		}
	},
	removeRegionFromContentGroup: function(region, group) {
		var g = ContentGroups.findOne({ slug: group });
		if(g && g.supportedRegions) {
			l = g.supportedRegions.length;
			while(l--) {
				if(g.supportedRegions[l] === region) {
					g.supportedRegions.splice(l, 1);
				}
			}
			var query = {_id: g._id}
			var options = { $set: {supportedRegions: g.supportedRegions }};
			return updateContentGroup(query, options);
		}
	},
	addLanguageToRegion: function(region, language) {
		var l, options, query, r;
		r = Regions.findOne({ slug: region });
		if (r) {
			if (!r.supportedLanguages) {
				r.supportedLanguages = [language];
			} else {
				l = r.supportedLanguages.length;
				while (l--) {
					if (r.supportedLanguages[l] === language) {
						return;
					}
				}
				r.supportedLanguages.push(language);
			}
			r.supportedLanguages.sort();
			query = { _id: r._id };
			options = { $set: { supportedLanguages: r.supportedLanguages }};
			return updateRegion(query, options);
		}
	},
	removeLanguageFromRegion: function(region, language) {
		var l, options, query, r;
		r = Regions.findOne({
			slug: region
		});
		if (r && r.supportedLanguages) {
			l = r.supportedLanguages.length;
			while (l--) {
				if (r.supportedLanguages[l] === language) {
					r.supportedLanguages.splice(l, 1);
				}
			}
			query = { _id: r._id };
			options = { $set: { supportedLanguages: r.supportedLanguages }};
			return updateRegion(query, options);
		}
	},
	addContentGroupToWebsite: function(group, website) {
		var w = Websites.findOne({ slug: website });
		if(w) {
			if(!w.supportedContentGroups) {
				w.supportedContentGroups = [group];
			} else {
				l = w.supportedContentGroups.length;
				while(l--) {
					if(w.supportedContentGroups[l] === group) {
						return;
					}
				}
				w.supportedContentGroups.push(group);
			}
			w.supportedContentGroups.sort();
			query = { _id: w._id};
			options = { $set: {supportedContentGroups: w.supportedContentGroups }};
			return updateWebsite(query, options);
		}
	},
	removeContentGroupFromWebsite: function(group, website) {
		var w = Websites.findOne({ slug: website });
		if(w && w.supportedContentGroups) {
			l = w.supportedContentGroups.length;
			while(l--) {
				if(w.supportedContentGroups[l] === group) {
					w.supportedContentGroups.splice(l, 1);
				}
			}
			query = { _id: w._id };
			options = { $set: { supportedContentGroups: w.supportedContentGroups }};
			return updateWebsite(query, options);
		}
	},
	addMenuToContentGroup: function(menu, group) {
		var g = ContentGroups.findOne({slug: group});
		if(g) {
			if(!g.supportedMenus) {
				g.supportedMenus = [menu];
			} else {
				l = g.supportedMenus.length;
				while(l--) {
					if(g.supportedMenus[l] === menu) {
						return;
					}
				}
				g.supportedMenus.push(menu);
			}
			g.supportedMenus.sort();
			var query = { _id: g._id };
			var options = { $set: { supportedMenus: g.supportedMenus }};
			return updateContentGroup(query, options);
		}
	},
	removeMenuFromContentGroup: function(menu, group) {
		var g = ContentGroups.findOne({ slug: group });
		if(g && g.supportedMenus) {
			l = g.supportedMenus.length;
			while(l--) {
				if(g.supportedMenus[l] === menu) {
					g.supportedMenus.splice(l, 1);
				}
			}
			var query = {_id: g._id};
			var options = { $set: {supportedMenus: g.supportedMenus }};
			return updateContentGroup(query, options);
		}
	},
	addPageToContentGroup: function(page, group) {
		var g = ContentGroups.findOne({slug: group});
		if(g) {
			if(!g.supportedPages) {
				g.supportedPages = [page];
			} else {
				l = g.supportedPages.length;
				while(l--) {
					if(g.supportedPages[l] === page) {
						return;
					}
				}
				g.supportedPages.push(page);
			}
			g.supportedPages.sort();
			var query = { _id: g._id };
			var options = { $set: { supportedPages: g.supportedPages }};
			return updateContentGroup(query, options);
		}
	},
	removePageFromContentGroup: function(page, group) {
		var g = ContentGroups.findOne({ slug: group });
		if(g && g.supportedPages) {
			l = g.supportedPages.length;
			while(l--) {
				if(g.supportedPages[l] === page) {
					g.supportedPages.splice(l, 1);
				}
			}
			var query = {_id: g._id};
			var options = { $set: {supportedPages: g.supportedPages }};
			return updateContentGroup(query, options);
		}
	}
};

if (Meteor.isServer) {
	var adminOnly = function(userId, doc, fields, modifier) {
		return Meteor.user().roles.admin;
	};
	var nameSlugRequired = function(userId, doc) {
		return userId && doc.name && doc.slug && Meteor.user().roles.admin;
	};
	var allowAll = function(userId, doc) {
		return true;
	};
	Languages.allow({
		insert: nameSlugRequired,
		update: adminOnly
	});
	Regions.allow({
		insert: nameSlugRequired,
		update: adminOnly
	});
	Websites.allow({
		insert: nameSlugRequired,
		update: adminOnly
	});
	ContentGroups.allow({
		insert: nameSlugRequired,
		update: adminOnly
	});
	Pages.allow({
		insert: nameSlugRequired,
		update: adminOnly
	});
	Menus.allow({
		insert: nameSlugRequired,
		update: adminOnly
	});
	AdminHistory.allow({
		insert: allowAll,
		update: allowAll
	});
}
