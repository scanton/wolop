objectifyFormArray = (arr) ->
	o = {}
	l = arr.length
	while l--
		d = arr[l]
		o[d.name] = d.value
	return o

t = Template

t.home.created = ->
	#console.log 'Created the home template'

t.home.rendered = ->
	#console.log 'Rendered the home template'

t.home.destroyed = ->
	#console.log 'Destroyed the home template'

t.home.helpers
	exampleHelper: ->
		new Spacebars.SafeString 'This text came from a helper with some <strong>HTML</strong>.'

t.loginRequired.events

	'submit': (e) ->
		e.preventDefault()
		$this = $ e.target
		username = $this.find('input[name="username"]').val()
		password = $this.find('input[name="password"]').val()
		Meteor.loginWithPassword username, password

t.contentGroups.events

	'click .add-item-button': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal
			backdrop: true
			keyboard: true

	'click .modal button': (e) ->
		$('.add-item-modal').modal 'hide'

	'submit .add-item-form': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='submit']").val ''
		if o.name && o.slug
			collections.insertContentGroup o

t.menus.events

	'click .add-item-button': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal
			backdrop: true
			keyboard: true

	'click .modal button': (e) ->
		$('.add-item-modal').modal 'hide'

	'submit .add-item-form': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='submit']").val ''
		if o.name && o.slug
			collections.insertMenu o

t.pages.events

	'click .add-item-button': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal
			backdrop: true
			keyboard: true

	'click .modal button': (e) ->
		$('.add-item-modal').modal 'hide'

	'submit .add-item-form': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='submit']").val ''
		if o.name && o.slug
			collections.insertPage o

t.regions.events

	'click .add-item-button': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal
			backdrop: true
			keyboard: true

	'click .modal button': (e) ->
		$('.add-item-modal').modal 'hide'

	'click .add-language-to-region': (e) ->
		$this = $ e.target
		lang = $this.attr 'data-slug'
		region = $this.closest('.region').attr 'data-slug'
		if lang && region
			collections.addLanguageToRegion region, lang

	'click .remove-language-from-region': (e) ->
		$this = $ e.target
		lang = $this.attr 'data-slug'
		region = $this.closest('.region').attr 'data-slug'
		if lang && region
			collections.removeLanguageFromRegion region, lang

	'submit .add-item-form': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='submit']").val ''
		if o.name && o.slug
			collections.insertRegion o

t.languages.events

	'click .add-item-button': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal
			backdrop: true
			keyboard: true

	'click .modal button': (e) ->
		$('.add-item-modal').modal 'hide'

	'submit .add-item-form': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='submit']").val ''
		if o.name && o.slug
			collections.insertLanguage o

t.websites.events

	'click .add-item-button': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal
			backdrop: true
			keyboard: true

	'click .modal button': (e) ->
		$('.add-item-modal').modal 'hide'

	'submit .add-item-form': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='submit']").val ''
		if o.name && o.slug && o.url
			collections.insertWebsite o