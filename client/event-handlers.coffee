Template.loginRequired.events

	'submit': (e) ->
		e.preventDefault()
		$this = $ e.target
		username = $this.find('input[name="username"]').val()
		password = $this.find('input[name="password"]').val()
		Meteor.loginWithPassword username, password
		