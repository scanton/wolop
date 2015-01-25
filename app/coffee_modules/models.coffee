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
	ContentGroup: mongoose.model('ContentGroup',
		name: String
		slug: {type: String, unique: true}
	)
	Region: mongoose.model('Region',
		name: String
		slug: {type: String, unique: true}
		languages: [
			type: Schema.ObjectId
			ref: 'Language'
		]
	)
	Language: mongoose.model('Language',
		name: String
		slug: {type: String, unique: true}
	)
	Menu: mongoose.model('Menu',
		name: String
		slug: {type: String, unique: true}
	)
	Page: mongoose.model('Page',
		name: String
		slug: {type: String, unique: true}
		content: String
		created: {type: Date, default: Date.now}
	)
	Website: mongoose.model('Website',
		name: String
		slug: {type: String, unique: true}
		domain: String
		#contentGroups: [{ type: Schema.ObjectId, ref: 'ContentGroup' }]
		contentGroups: Array
		languages: Array
		regions: Array
	)
