app = angular.module 'utils', []

app.factory 'sortByName', ->
	(a, b) ->
		if a.name > b.name
			return 1
		if a.name < b.name
			return -1
		0