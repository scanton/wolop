express = require('express')
router = express.Router()

router.get '/', (req, res) ->
	res.render 'index',
		title: 'Wolop'

module.exports = router
