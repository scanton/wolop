t = Template
t.registerHelper 'formatTime', (time, type) ->
	switch type
		when 'fromNow'
			return moment.unix(time).fromNow()
		when 'iso'
			return moment.unix(time).toISOString()
		else
			return moment.unix(time).format('LLLL')

t.languages.helpers
	languages: ->
		Languages.find {}

t.regions.helpers
	languages: ->
		Languages.find {}
	regions: ->
		Regions.find {}