t = Template
t.registerHelper 'formatTime', (time, type) ->
	switch type
		when 'fromNow'
			return moment.unix(time).fromNow()
		when 'iso'
			return moment.unix(time).toISOString()
		else
			return moment.unix(time).format('LLLL')

Session.set 'delete-enabled', false
t.layout.helpers
	adminHistory: ->
		AdminHistory.find {}, {limit: 15}
	deleteEnabled: ->
		return Session.get 'delete-enabled'
	deleteEnabledClass: ->
		return if Session.get('delete-enabled') then 'delete-enabled' else 'delete-disabled'

t.contentGroups.helpers
	contentGroups: ->
		ContentGroups.find {}
	languages: ->
		Languages.find {}
	regions: ->
		Regions.find {}
	menus: ->
		Menus.find {}
	pages: ->
		Pages.find {}

t.languages.helpers
	languages: ->
		Languages.find {}

t.menus.helpers
	menus: ->
		Menus.find {}

t.pages.helpers
	pages: ->
		Pages.find {}

t.regions.helpers
	languages: ->
		Languages.find {}
	regions: ->
		Regions.find {}

t.websites.helpers
	websites: ->
		Websites.find {}, {sort: {name: 1}}
	contentGroups: ->
		ContentGroups.find {}