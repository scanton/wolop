Template.breadcrumbs.events
	'click .admin-menu-toggle': (e) ->
		e.preventDefault()
		Session.set 'show-main-nav', !Session.get('show-main-nav', false)