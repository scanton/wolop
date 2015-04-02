Template.menus.helpers

	menus: ->
		Menus.find {}, { sort: { slug: 1 } }

Template.menus.events

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
			collections.insertMenu o

Template.editMenuDetails.helpers

	contentGroup: ->
		ContentGroups.findOne { slug: @group }

	menu: ->
		Menus.findOne { slug: @menu, contentGroup: @group }

	filterUsedPages: (pages) ->
		if pages
			menu = Menus.findOne { slug: @menu, contentGroup: @group }
			if menu
				sp = menu.supportedPages || []
				a = []
				l = pages.length
				while l--
					page = pages[l]
					isUsed = false
					l2 = sp.length
					while l2--
						if sp[l2] == page
							isUsed = true
					if !isUsed
						a.push page
				a.sort()
				return a

	getPageName: (slug) ->
		p = Pages.findOne { slug: slug }
		if p
			return p.name
		return slug

Template.editMenuDetails.events

	'click .set-region-and-language': (e) ->
		e.preventDefault()
		$this = $ e.target
		lang = $this.attr 'data-slug'
		region = $this.closest('.region').attr 'data-slug'
		Session.set 'current-region', region
		Session.set 'current-language', lang

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

