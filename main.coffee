Accounts.config
	forbidClientAccountCreation: true

if Meteor.isClient
	Meteor.subscribe 'user-roles'
	Meteor.subscribe 'languages'
	Meteor.subscribe 'regions'
	window.Wolop = Meteor
	window.objectify = (arr) ->
		a = []
		l = arr.length
		while l--
			val = arr[l]
			a.unshift { name: val[0], link: val[1], icon: val[2] }
		return a