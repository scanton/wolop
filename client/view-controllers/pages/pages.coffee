Template.pages.helpers
	pages: ->
		Pages.find {}, { sort: { name: 1 } }

Template.pages.events
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
		$(e.target).find("input").not("input[type='hidden']").not("input[type='submit']").val ''
		if o.name && o.slug
			collections.insertPage o

Template.editPageLocalization.helpers

	website: ->
		Websites.findOne { slug: @website }

	contentGroup: ->
		ContentGroups.findOne { slug: @group }

	showChecked: (val) ->
		if val == 'on'
			return 'checked'
		return ''

	getPageLocalization: (page) ->
		region = Session.get 'current-region'
		language = Session.get 'current-language'
		group = Session.get 'content-group-context'
		PageLocalizations.findOne { page: page, region: region, language: language, contentGroup: group }

	isNotActiveGroup: (slug) ->
		slug != Session.get 'content-group-context'

Template.editPageLocalization.events

	'click .set-region-and-language': (e) ->
		e.preventDefault()
		$this = $ e.target
		lang = $this.attr 'data-slug'
		region = $this.closest('.region').attr 'data-slug'
		Session.set 'current-region', region
		Session.set 'current-language', lang

	'submit .page-details-form': (e) ->
		e.preventDefault()
		$this = $ e.target
		o = objectifyFormArray $this.serializeArray()
		if o.region && o.language
			collections.updatePageDetails o
