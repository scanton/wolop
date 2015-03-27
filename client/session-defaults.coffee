Session.set 'show-main-nav', false
Session.set 'delete-enabled', false
Session.set('admin-history-limit', 5) if Session.get('admin-history-limit') == undefined
