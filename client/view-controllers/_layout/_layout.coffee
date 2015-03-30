Template.layout.helpers

	adminHistory: ->
		AdminHistory.find {}, { limit: Session.get 'admin-history-limit' }

	deleteEnabled: ->
		Session.get 'delete-enabled'

	deleteEnabledClass: ->
		if Session.get('delete-enabled') then 'delete-enabled' else 'delete-disabled'

	adminHistoryLimit: ->
		Session.get 'admin-history-limit'

	getUserDetails: (id) ->
		Meteor.users.findOne { _id: id }

	getGlobalWrapperClasses: ->
		if Session.get('show-main-nav') then 'show-main-nav' else 'hide-main-nav'

	currentYear: ->
		new Date().getFullYear()

Template.layout.events

	'click .team-status-toggle': (e) ->
		e.preventDefault()
		ts = $(e.target).closest '.team-status'
		if ts.hasClass 'show-details'
			ts.removeClass 'show-details'
		else
			ts.addClass 'show-details'
	
	'click .allow-delete-toggle': (e) ->
		e.preventDefault()
		Session.set 'delete-enabled', !Session.get('delete-enabled')

	'change .select-admin-history-limit input': (e) ->
		e.preventDefault()
		val = Number $(e.target).val()
		if val > 0
			Session.set 'admin-history-limit', val