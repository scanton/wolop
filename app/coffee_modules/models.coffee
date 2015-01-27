mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports =
	Admin: mongoose.model('Admin',
		firstName: String
		lastName: String
		email: {type: String, unique: true}
		username: {type: String, unique: true}
		password: String
	)
	Content: mongoose.model('Content',
		page: {type: Schema.Types.ObjectId, ref: 'Page'}
		region: {type: Schema.Types.ObjectId, ref: 'Region'}
		language: {type: Schema.Types.ObjectId, ref: 'Language'}
		content: String
		creator: {type: Schema.Types.ObjectId, ref: 'Admin'}
		created: {type: Date, default: Date.now}
	)
	ContentHistory: mongoose.model('ContentHistory',
		page: {type: Schema.Types.ObjectId, ref: 'Page'}
		region: {type: Schema.Types.ObjectId, ref: 'Region'}
		language: {type: Schema.Types.ObjectId, ref: 'Language'}
		content: String
		creator: {type: Schema.Types.ObjectId, ref: 'Admin'}
		created: {type: Date}
	)
	ContentGroup: mongoose.model('ContentGroup',
		name: String
		slug: {type: String, unique: true}
		parent: {type: Schema.Types.ObjectId, ref: 'ContentGroup'}
		menus: [
			type: Schema.Types.ObjectId
			ref: 'Menu'
		]
		pages: [
			type: Schema.Types.ObjectId
			ref: 'Page'
		]
	)
	Region: mongoose.model('Region',
		name: String
		slug: {type: String, unique: true}
		languages: [
			type: Schema.Types.ObjectId
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
			type: Schema.Types.ObjectId
			ref: 'Page'
		]
	)
	Page: mongoose.model('Page',
		name: String
		slug: {type: String, unique: true}
		created: {type: Date, default: Date.now}
		creator: {type: Schema.Types.ObjectId, ref: 'Admin'}
	)
	Website: mongoose.model('Website',
		name: String
		slug: {type: String, unique: true}
		domain: String
		contentGroups: [
			type: Schema.ObjectId
			ref: 'ContentGroup'
			unique: true
		]
		regions: [
			type: Schema.ObjectId
			ref: 'Region'
			unique: true
		]
	)
