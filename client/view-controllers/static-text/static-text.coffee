Template.editManagedStaticTextLocalization.helpers

	contentGroup: ->
		ContentGroups.findOne { slug: @group }

	showChecked: (val) ->
		if val == 'on'
			return 'checked'
		return ''

	getManagedStaticTextLocalization: (slug) ->
		region = Session.get 'current-region'
		language = Session.get 'current-language'
		group = Session.get 'content-group-context'
		ManagedStaticTextLocalizations.findOne { managedStaticText: slug, region: region, language: language, contentGroup: group }

Template.editManagedStaticTextLocalization.events

	'click .set-region-and-language': (e) ->
		e.preventDefault()
		$this = $ e.target
		lang = $this.attr 'data-slug'
		region = $this.closest('.region').attr 'data-slug'
		Session.set 'current-region', region
		Session.set 'current-language', lang

	'submit .managed-static-text-details-form': (e) ->
		e.preventDefault()
		$this = $ e.target
		o = objectifyFormArray $this.serializeArray()
		if o.region && o.language
			collections.updateManagedStaticTextDetails o