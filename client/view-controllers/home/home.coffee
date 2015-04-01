Template.home.created = ->
	#console.log 'This is the "home.created" event.'
	#initialize view (if needed)

Template.home.rendered = ->
	#console.log 'This is the "home.rendered" event.'
	#jquery magic if necessary

Template.home.destroyed = ->
	#console.log 'This is the "home.destroyed" event.'
	#clean up

Template.home.helpers

	websites: ->
		Websites.find { isActive: 'on' }, { sort: { name: 1 } }

	contentGroups: ->
		ContentGroups.find {}, { sort: { slug: 1 } }

	regions: ->
		Regions.find {}, { sort: { name: 1 } }

	getContentGroupDetails: (slug) ->
		ContentGroups.findOne { slug: slug }

	deleteEnabled: ->
		Session.get 'delete-enabled'

	getRiskAsBsClass: __coffeescriptShare.riskBs

Template.home.events

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
			Router.go '/edit-content-group/' + website + '/' + slug
			
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
		now = new Date()
		$('.add-item-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		supportedRegions = [o.supportedRegions]
		delete o.supportedRegions
		o.created = now
		$(e.target).find("input").not("input[type='hidden']").not("input[type='submit']").val ''
		if o.name && o.slug && o.url
			o.supportedContentGroups = [
				o.slug + '-production'
				o.slug + '-staging'
				o.slug + '-test'
			]
			collections.insertWebsite o
			defaultGroups = [
				{ name: 'Production', slug: 'production', risk: 'high' }
				{ name: 'Staging', slug: 'staging', risk: 'medium' }
				{ name: 'Test', slug: 'test', risk: 'low' }
			]
			defaultMenus = [
				{ name: 'Top', slug: 'top', }
				{ name: 'Side', slug: 'side', }
				{ name: 'Footer', slug: 'footer', }
			]
			dm = menu = group = null
			dl = defaultGroups.length
			while dl--
				supportedMenus = []
				group = defaultGroups[dl]
				dm = defaultMenus.length
				while dm--
					menu = defaultMenus[dm]
					menuSlug = o.slug + '-' + group.slug + '-' + menu.slug
					supportedMenus.push menuSlug
					collections.insertMenu
						name: menu.name
						slug: menuSlug
						isActive: 'on'
						created: now
				collections.insertContentGroup
					name: group.name
					slug: o.slug + '-' + group.slug
					riskLevel: group.risk
					supportedRegions: supportedRegions
					supportedMenus: supportedMenus
					isActive: 'on'
					created: now

