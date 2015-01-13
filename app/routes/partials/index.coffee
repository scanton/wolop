express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
	res.render 'index',
		title: 'Partials folder'

router.get '*', (req, res) ->
	template = req.url.replace('.html', '')
	console.log 'partials' + template
	res.render 'partials' + template
module.exports = router
