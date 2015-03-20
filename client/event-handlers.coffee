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

t.layout.events
	
	'click .allow-delete-toggle': (e) ->
		Session.set 'delete-enabled', !Session.get('delete-enabled')

	'change .select-admin-history-limit input': (e) ->
		val = Number $(e.target).val()
		if val > 0
			Session.set 'admin-history-limit', val

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

	'click .add-region-to-content-group': (e) ->
		e.preventDefault()
		$this = $ e.target
		region = $this.attr 'data-slug'
		group = $this.closest('.content-group').attr 'data-slug'
		if region && group
			collections.addRegionToContentGroup region, group

	'click .remove-region-from-content-group': (e) ->
		e.preventDefault()
		$this = $ e.target
		region = $this.closest('.delete-button').attr 'data-slug'
		group = $this.closest('.content-group').attr 'data-slug'
		if region && group
			collections.removeRegionFromContentGroup region, group

	'click .add-menu-to-content-group': (e) ->
		e.preventDefault()
		$this = $ e.target
		menu = $this.attr 'data-slug'
		group = $this.closest('.content-group').attr 'data-slug'
		if menu && group
			collections.addMenuToContentGroup menu, group

	'click .remove-menu-from-content-group': (e) ->
		e.preventDefault()
		$this = $ e.target
		menu = $this.closest('.delete-button').attr 'data-slug'
		group = $this.closest('.content-group').attr 'data-slug'
		if menu && group
			collections.removeMenuFromContentGroup menu, group

	'click .add-page-to-content-group': (e) ->
		e.preventDefault()
		$this = $ e.target
		page = $this.attr 'data-slug'
		group = $this.closest('.content-group').attr 'data-slug'
		if page && group
			collections.addPageToContentGroup page, group

	'click .remove-page-from-content-group': (e) ->
		e.preventDefault()
		$this = $ e.target
		page = $this.closest('.delete-button').attr 'data-slug'
		group = $this.closest('.content-group').attr 'data-slug'
		if page && group
			collections.removePageFromContentGroup page, group

	'click .edit-menu-button': (e) ->
		e.preventDefault()
		$this = $ e.target
		group = $this.closest('.content-group').attr 'data-slug'
		menu = $this.attr 'data-slug'
		Router.go '/edit-menu-details/' + menu + '/' + group

	'click .edit-page-button': (e) ->
		e.preventDefault()
		$this = $ e.target
		group = $this.closest('.content-group').attr 'data-slug'
		page = $this.attr 'data-slug'
		Router.go '/edit-page-details/' + page + '/' + group

	'submit .add-item-form': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='submit']").val ''
		if o.name && o.slug
			collections.insertContentGroup o

setRegionLanguageHandler = (e) ->
	e.preventDefault()
	$this = $ e.target
	lang = $this.attr 'data-slug'
	region = $this.closest('.region').attr 'data-slug'
	Session.set 'current-region', region
	Session.set 'current-language', lang
	
t.editMenuDetails.events
	'click .set-region-and-language': setRegionLanguageHandler

	'click .add-page-to-menu-button': (e) ->
		e.preventDefault()
		$this = $ e.target
		page = $this.closest('button').attr 'data-slug'
		menu = $this.closest('.menu').attr 'data-slug'
		collections.addPageToMenu page, menu

	'click .remove-page-from-menu-button': (e) ->
		e.preventDefault()
		$this = $ e.target
		page = $this.closest('button').attr 'data-slug'
		menu = $this.closest('.menu').attr 'data-slug'
		collections.removePageFromMenu page, menu

	'click .move-page-up': (e) ->
		e.preventDefault()
		$this = $ e.target
		page = $this.closest('button').attr 'data-slug'
		menu = $this.closest('.menu').attr 'data-slug'
		collections.movePageUpOnMenu page, menu

	'click .move-page-down': (e) ->
		e.preventDefault()
		$this = $ e.target
		page = $this.closest('button').attr 'data-slug'
		menu = $this.closest('.menu').attr 'data-slug'
		collections.movePageDownOnMenu page, menu

t.editPageLocalization.events
	'click .set-region-and-language': setRegionLanguageHandler

	'submit .page-details-form': (e) ->
		e.preventDefault()
		$this = $ e.target
		o = objectifyFormArray $this.serializeArray()
		if o.region && o.language
			collections.updatePageDetails o

t.editWebsiteContentGroup.events
	'click .set-region-and-language': setRegionLanguageHandler
	
t.home.events
	'click .disable-website': (e) ->
		e.preventDefault()
		slug = $(e.target).attr 'data-slug'
		if (Session.get 'delete-enabled') && slug
			collections.deactivateWebsite slug

	'click .edit-content-group-button': (e) ->
		e.preventDefault()
		$this = $ e.target
		slug = $this.attr 'data-slug'
		website = $this.closest('.website').attr 'data-slug'
		if slug && website
			Session.set 'website-context', website
			Session.set 'content-group-context', slug
			Router.go '/edit-website-content-group/' + website + '/' + slug

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
		lang = $this.closest('.delete-button').attr 'data-slug'
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
	'click .reactivate-button': (e) ->
		e.preventDefault()
		slug = $(e.target).attr 'data-slug'
		collections.reactivateWebsite slug

	'click .add-item-button': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal
			backdrop: true
			keyboard: true

	'click .modal button': (e) ->
		$('.add-item-modal').modal 'hide'

	'click .add-content-group-to-website': (e) ->
		$this = $ e.target
		group = $this.attr 'data-slug'
		website = $this.closest('.website').attr 'data-slug'
		if website && group
			collections.addContentGroupToWebsite group, website

	'click .remove-content-group-from-website': (e) ->
		$this = $ e.target
		group = $this.closest('.delete-button').attr 'data-slug'
		website = $this.closest('.website').attr 'data-slug'
		if group && website
			collections.removeContentGroupFromWebsite group, website

	'submit .add-item-form': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='submit']").val ''
		if o.name && o.slug && o.url
			collections.insertWebsite o
