Template.regions.helpers

	languages: ->
		Languages.find {}, { sort: { name: 1 } }

	regions: ->
		Regions.find {}, { sort: { name: 1 } }

Template.regions.events

	'click .add-item-button': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal
			backdrop: true
			keyboard: true

	'click .modal button': (e) ->
		$('.add-item-modal').modal 'hide'

	'click .add-language-to-region': (e) ->
		e.preventDefault()
		$this = $ e.target
		lang = $this.attr 'data-slug'
		region = $this.closest('.region').attr 'data-slug'
		if lang && region
			collections.addLanguageToRegion region, lang

	'click .remove-language-from-region': (e) ->
		e.preventDefault()
		$this = $ e.target
		lang = $this.closest('.delete-button').attr 'data-slug'
		region = $this.closest('.region').attr 'data-slug'
		if lang && region
			collections.removeLanguageFromRegion region, lang

	'submit .add-item-form': (e) ->
		e.preventDefault()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray data
		$(e.target).find("input").not("input[type='hidden']").not("input[type='submit']").val ''
		if o.name && o.slug
			collections.insertRegion o
