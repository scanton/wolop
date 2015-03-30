Template.contentGroups.helpers
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

Template.contentGroups.events

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
		$(e.target).find("input").not("input[type='hidden']").not("input[type='submit']").val ''
		if o.name && o.slug
			collections.insertContentGroup o

Template.editWebsiteContentGroup.helpers
	getRiskLabel: __coffeescriptShare.riskBsLabel
	website: ->
		Websites.findOne { slug: @website }
	contentGroup: ->
		ContentGroups.findOne { slug: @group }

Template.editWebsiteContentGroup.events
	'click .set-region-and-language': (e) ->
		e.preventDefault()
		$this = $ e.target
		lang = $this.attr 'data-slug'
		region = $this.closest('.region').attr 'data-slug'
		Session.set 'current-region', region
		Session.set 'current-language', lang

	'click .add-page-button': (e) ->
		e.preventDefault()
		$('.add-page-modal').modal
			backdrop: true
			keyboard: true

	'click .add-menu-button ': (e) ->
		e.preventDefault()
		$('.add-menu-modal').modal
			backdrop: true
			keyboard: true

	'click .add-menu-modal button': (e) ->
		$('.add-menu-modal').modal 'hide'

	'click .add-page-modal button': (e) ->
		$('.add-page-modal').modal 'hide'

	'submit .add-menu-form': (e) ->
		e.preventDefault()
		$('.add-menu-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='hidden']").not("input[type='submit']").val ''
		if o.name && o.slug && o.contentGroup
			slug = o.contentGroup
			delete o.contentGroup
			collections.insertMenu o
			group = collections.getContentGroup slug
			if group
				supportedMenus = group.supportedMenus || []
				supportedMenus.unshift o.slug
				collections.updateContentGroup { _id: group._id }, { $set: { supportedMenus: supportedMenus } }

	'submit .add-page-form': (e) ->
		e.preventDefault()
		$('.add-page-modal').modal 'hide'
		data = $(e.target).serializeArray()
		o = objectifyFormArray(data)
		$(e.target).find("input").not("input[type='hidden']").not("input[type='submit']").val ''
		if o.name && o.slug
			slug = o.contentGroup
			delete o.contentGroup
			collections.insertPage o
			group = collections.getContentGroup slug
			if group
				supportedPages = group.supportedPages || []
				supportedPages.unshift o.slug
				collections.updateContentGroup { _id: group._id }, { $set: { supportedPages: supportedPages } }