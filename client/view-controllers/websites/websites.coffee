Template.websites.helpers

	websites: ->
		Websites.find {}, { sort: { name: 1 } }

	contentGroups: ->
		ContentGroups.find {}

	canReactivate: (slug) ->
		w = Websites.findOne { slug: slug }
		return w.isActive != 'on'

Template.websites.events

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
		e.preventDefault()
		$this = $ e.target
		group = $this.attr 'data-slug'
		website = $this.closest('.website').attr 'data-slug'
		if website && group
			collections.addContentGroupToWebsite group, website

	'click .remove-content-group-from-website': (e) ->
		e.preventDefault()
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
		$(e.target).find("input").not("input[type='hidden']").not("input[type='submit']").val ''
		if o.name && o.slug && o.url
			collections.insertWebsite o

Template.websiteDetails.helpers

	getWebsiteSlug: ->
		Template.parentData(2).slug

	slugUp: (int)->
		Template.parentData(int).slug if Template.parentData(int)

Template.websiteDetails.events
	
	'click button.add-notice': (e) ->
		e.preventDefault()
		console.log 'yizzy'

	'click button.add-menu': (e) ->
		e.preventDefault()
		console.log 'add mizzy'

	'click button.add-page': (e) ->
		e.preventDefault()
		console.log 'add pizzy'

	'click button.add-region': (e) ->
		e.preventDefault()
		console.log 'add rizzy'

	'click button.add-managed-static-text': (e) ->
		e.preventDefault()
		console.log 'add meezy sizzy tizzy'