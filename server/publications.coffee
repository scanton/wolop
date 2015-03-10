Meteor.publish 'user-roles', ->
	if @userId
		return Meteor.users.find {_id: @userId}, {fields: {roles: 1}}
	else
		@ready()

Meteor.publish 'languages', ->
	if @userId
		return Languages.find {}, {sort: {slug: 1}}
	else
		@ready()

Meteor.publish 'regions', ->
	if @userId
		return Regions.find {}, {sort: {slug: 1}}
	else
		@ready()