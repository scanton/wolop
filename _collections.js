ContentGroups = new Mongo.Collection('content_groups');
Languages = new Mongo.Collection('languages');
Menus = new Mongo.Collection('menus');
Notices = new Mongo.Collection('notices');
Pages = new Mongo.Collection('pages');
PageLocalizations = new Mongo.Collection('page_localizations');
Products = new Mongo.Collection('products');
Regions = new Mongo.Collection('regions');
ManagedStaticText = new Mongo.Collection('managed_static_text');
ManagedStaticTextLocalizations = new Mongo.Collection('managed_static_text_localizations');
StaticText = new Mongo.Collection('static_text');
StaticTextLocalizations = new Mongo.Collection('static_text_localizations');
Websites = new Mongo.Collection('websites');
AdminHistory = new Mongo.Collection('admin_history');

collections = {}
defineCollectionApi = function(obj) {
	collections = obj;
}
