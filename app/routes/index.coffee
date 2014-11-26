express = require('express')
router = express.Router()

router.get '/', (req, res) ->
	res.render 'index',
		title: 'Wolop'

pageHandler = (req, res) ->
	res.render 'page',
		title: 'Web Page'

router.get '/web-page/:index?', pageHandler
router.get '/web-section/:index?', pageHandler
router.get '/product-category/:index?', pageHandler

router.get '/forgot-password/:index?', (req, res) ->
	res.render 'forgot_password',
		title: 'Forgot Password'

router.get '/gallery-view/:index?', (req, res) ->
	res.render 'gallery_view',
		title: 'Gallery View'

router.get '/lifeplus-formula/:index?', (req, res) ->
	res.render 'lifeplus_formula',
		title: 'Lifeplus Formula'

router.get '/manage-account/:index?', (req, res) ->
	res.render 'manage_account',
		title: 'Manage Account'

router.get '/product-details/:index?', (req, res) ->
	res.render 'product_details',
		title: 'Product Details'

router.get '/reset-password/:index?', (req, res) ->
	res.render 'reset_password',
		title: 'Reset Password'

router.get '/search-result/:index?', (req, res) ->
	res.render 'search_result',
		title: 'Search Result'

router.get '/secure-checkout/:index?', (req, res) ->
	res.render 'secure_checkout',
		title: 'Secure Checkout'

router.get '/shop-now/:index?', (req, res) ->
	res.render 'shop_now',
		title: 'Shop Now'

router.get '/user-account/:index?', (req, res) ->
	res.render 'user_account',
		title: 'User Account'

router.get '/user-login/:index?', (req, res) ->
	res.render 'user_login',
		title: 'User Login'

router.get '/user-logout/:index?', (req, res) ->
	res.render 'user_logout',
		title: 'User Logout'

router.get '/user-register/:index?', (req, res) ->
	res.render 'user_register',
		title: 'User Register'

router.get '/verify-security-question/:index?', (req, res) ->
	res.render 'verify_security_question',
		title: 'Verify Security Question'

router.get '/view-cart/:index?', (req, res) ->
	res.render 'view_cart',
		title: 'View Cart'

router.get '/view-video/:index?', (req, res) ->
	res.render 'view_video',
		title: 'View Video'

module.exports = router