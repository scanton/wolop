ContentGroups = new Mongo.Collection('content_groups');
Languages = new Mongo.Collection('languages');
Menus = new Mongo.Collection('menus');
Notices = new Mongo.Collection('notices');
Pages = new Mongo.Collection('pages');
PageLocalizations = new Mongo.Collection('page_localizations');
Products = new Mongo.Collection('products');
Regions = new Mongo.Collection('regions');
StaticText = new Mongo.Collection('static_text');
Websites = new Mongo.Collection('websites');
AdminHistory = new Mongo.Collection('admin_history');

collections = {}
defineCollectionApi = function(obj) {
	collections = obj;
}
