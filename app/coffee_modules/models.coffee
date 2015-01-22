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
		name: {type: String, unique: true}
		slug: {type: String, unique: true}
	)
	Locale: mongoose.model('Locale',
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
		created: Date
	)
	Website: mongoose.model('Website',
		name: String
		slug: {type: String, unique: true}
		domain: String
		#contentGroups: [{ type: Schema.ObjectId, ref: 'ContentGroup' }]
		contentGroups: Array
		locales: Array
	)
