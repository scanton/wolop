t = Template
t.registerHelper 'formatTime', (time, type) ->
	switch type
		when 'fromNow'
			return moment.unix(time).fromNow()
		when 'iso'
			return moment.unix(time).toISOString()
		else
			return moment.unix(time).format('LLLL')

t.layout.helpers
	adminHistory: ->
		AdminHistory.find {}, {limit: 10}

t.contentGroups.helpers
	contentGroups: ->
		ContentGroups.find {}
	languages: ->
		Languages.find {}
	regions: ->
		Regions.find {}

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