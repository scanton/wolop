ContentGroups = new Mongo.Collection('content_groups');
Languages = new Mongo.Collection('languages');
Menus = new Mongo.Collection('menus');
Notices = new Mongo.Collection('notices');
Pages = new Mongo.Collection('pages');
Products = new Mongo.Collection('products');
Regions = new Mongo.Collection('regions');
StaticText = new Mongo.Collection('static_text');
Websites = new Mongo.Collection('websites');


if(Meteor.isServer) {
	var adminOnly = function (userId, doc, fields, modifier) {
        return Meteor.user().roles.admin;
    }
    var nameSlugRequired = function (userId, doc) {
        return userId && doc.name && doc.slug && Meteor.user().roles.admin;
    }
    Languages.allow({
        insert: nameSlugRequired,
        update: adminOnly
    });
    Regions.allow({
        insert: nameSlugRequired,
        update: adminOnly
    });
}