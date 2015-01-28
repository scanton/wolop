mongoose = require 'mongoose'
Schema = mongoose.Schema
MongoId = Schema.Types.ObjectId

module.exports =
	Admin: mongoose.model('Admin',
		firstName: String
		lastName: String
		email: {type: String, unique: true}
		username: {type: String, unique: true}
		password: String
	)
	Content: mongoose.model('Content',
		page: {type: MongoId, ref: 'Page'}
		region: {type: MongoId, ref: 'Region'}
		language: {type: MongoId, ref: 'Language'}
		content: String
		creator: {type: MongoId, ref: 'Admin'}
		created: {type: Date, default: Date.now}
	)
	ContentHistory: mongoose.model('ContentHistory',
		page: {type: MongoId, ref: 'Page'}
		region: {type: MongoId, ref: 'Region'}
		language: {type: MongoId, ref: 'Language'}
		content: String
		creator: {type: MongoId, ref: 'Admin'}
		created: {type: Date}
	)
	ContentGroup: mongoose.model('ContentGroup',
		name: String
		slug: {type: String, unique: true}
		parent: {type: MongoId, ref: 'ContentGroup'}
		menus: [
			type: MongoId
			ref: 'Menu'
		]
		pages: [
			type: MongoId
			ref: 'Page'
		]
	)
	Region: mongoose.model('Region',
		name: String
		slug: {type: String, unique: true}
		languages: [
			type: MongoId
			ref: 'Language'
		]
		icon: String
	)
	Language: mongoose.model('Language',
		name: String
		slug: {type: String, unique: true}
	)
	Menu: mongoose.model('Menu',
		name: String
		slug: {type: String, unique: true}
		pages: [
			type: MongoId
			ref: 'Page'
		]
	)
	Page: mongoose.model('Page',
		name: String
		slug: {type: String, unique: true}
		created: {type: Date, default: Date.now}
		creator: {type: MongoId, ref: 'Admin'}
	)
	Website: mongoose.model('Website',
		name: String
		slug: {type: String, unique: true}
		domain: String
		contentGroups: [
			type: MongoId
			ref: 'ContentGroup'
		]
		regions: [
			type: MongoId
			ref: 'Region'
		]
	)
