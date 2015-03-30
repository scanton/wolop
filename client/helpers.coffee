helper = Template.registerHelper
helper 'formatTime', (time, type) ->
	switch type
		when 'fromNow'
			return moment.unix(time).fromNow()
		when 'iso'
			return moment.unix(time).toISOString()
		else
			return moment.unix(time).format('LLLL')

__coffeescriptShare.intToRGB = (i) ->
	(i >> 16 & 0xFF).toString(16) + (i >> 8 & 0xFF).toString(16) + (i & 0xFF).toString(16)
__coffeescriptShare.hashCode = (str) ->
	hash = 0
	i = 0
	while i < str.length
		hash = str.charCodeAt(i) + (hash << 5) - hash
		i++
	hash
__coffeescriptShare.riskBs = (riskLevel) ->
	if riskLevel == 'low'
		return 'btn-success'
	if riskLevel == 'medium'
		return 'btn-warning'
	if riskLevel == 'high'
		return 'btn-danger'
	return 'btn-default'
__coffeescriptShare.riskBsLabel = (riskLevel) ->
	if riskLevel == 'low'
		return 'success'
	if riskLevel == 'medium'
		return 'warning'
	if riskLevel == 'high'
		return 'danger'
	return 'default'

helper 'intToRGB', __coffeescriptShare.intToRGB
helper 'hashCode', __coffeescriptShare.hashCode
helper 'getRiskAsBsClass', __coffeescriptShare.riskBs
helper 'getRiskLabel', __coffeescriptShare.riskBsLabel
helper 'websiteContext', ->
	Websites.findOne {slug: Session.get 'website-context'}
helper 'contentGroupContext', ->
	ContentGroups.findOne {slug: Session.get 'content-group-context'}
helper 'regionContext', ->
	Regions.findOne { slug: Session.get('current-region') }
helper 'languageContext', ->
	Languages.findOne { slug: Session.get('current-language') }
helper 'hashColor', (str) ->
	__coffeescriptShare.intToRGB __coffeescriptShare.hashCode(str)
helper 'getWebsite', (slug) ->
	Websites.findOne { slug: slug }
helper 'getContentGroup', (slug) ->
	ContentGroups.findOne { slug: slug }
helper 'getRegion', (region) ->
	Regions.findOne { slug: region }
helper 'getLanguage', (language) ->
	Languages.findOne { slug: language }
helper 'getMenu', (slug) ->
	Menus.findOne { slug: slug }
helper 'getPage', (slug) ->
	Pages.findOne { slug: slug }
helper 'getPageDetails', (slug) ->
	PageDetails.findOne { parent: slug, region: Session.get('region-context'), language: Session.get('language-context') }
helper 'coworkers', ->
	Presences.find {}
helper 'isCurrentLanguage', (lang) ->
	if Session.get('current-language') == lang
		return 'active-language'
	else
		return ''
helper 'isCurrentRegion', (region) ->
	if Session.get('current-region') == region
		return 'active-region'
	else
		return ''
helper 'isActivePath', (str) ->
	path = Router.current().route._path
	if str == '/home' && path == '/' 
		return 'active'
	if path == str then 'active' else ''
