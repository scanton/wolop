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

Meteor.publish 'websites', ->
	if @userId
		return Websites.find {}, {sort: {slug: 1}}
	else
		@ready()

Meteor.publish 'content-groups', ->
	if @userId
		return ContentGroups.find {}, {sort: {slug: 1}}
	else
		@ready()

Meteor.publish 'pages', ->
	if @userId
		return Pages.find {}, {sort: {slug: 1}}
	else
		@ready()

Meteor.publish 'menus', ->
	if @userId
		return Menus.find {}, {sort: {slug: 1}}
	else
		@ready()

Meteor.publish 'admin-history', ->
	if @userId
		return AdminHistory.find {}, {sort: {created: -1}}
	else
		@ready()