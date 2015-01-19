(function() {
  var app, socket;

  app = angular.module('wolop-cms', ['ui.bootstrap', 'ngRoute', 'ui.ace']);

  app.controller('CmsController', function($scope, $log) {
    $scope.isLoggedIn = false;
    $scope.userData = {};
    $scope.newUser = {};
    return socket.on('login-success', function(data) {
      return $scope.$apply(function() {
        $scope.userData = data;
        return $scope.isLoggedIn = true;
      });
    });
  });

  socket = io();

  app.factory('globalModel', function() {
    var model;
    model = {
      websites: [],
      contentGroups: [],
      locales: [],
      menus: [],
      pages: [],
      users: [],
      peers: [],
      messages: []
    };
    socket.on('websites-update', function(data) {
      return model.websites = data;
    });
    socket.on('content-groups-update', function(data) {
      return model.contentGroups = data;
    });
    socket.on('locales-update', function(data) {
      return model.locales = data;
    });
    socket.on('menus-update', function(data) {
      return model.menus = data;
    });
    socket.on('pages-update', function(data) {
      return model.pages = data;
    });
    socket.on('users-update', function(data) {
      return model.users = data;
    });
    return {
      getUsers: function() {
        return model.users;
      },
      getWebsites: function() {
        return model.websites;
      },
      getContentGroups: function() {
        return model.contentGroups;
      },
      getLocales: function() {
        return model.locales;
      },
      getMenus: function() {
        return model.menus;
      },
      getPages: function() {
        return model.pages;
      }
    };
  });

  app.directive('chatWidget', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/chat-widget.html',
      controller: function($scope, $log) {
        $scope.peers = {};
        $scope.chatArray = [];
        $scope.sendMessage = function(message) {
          return socket.emit('chat-message', message);
        };
        socket.on('chat-message-update', function(data) {
          return $scope.$apply(function() {
            return $scope.chatArray.push(data);
          });
        });
        return socket.on('auth-users-update', function(data) {
          return $scope.$apply(function() {
            return $scope.peers = data;
          });
        });
      }
    };
  });

  app.directive('userLogin', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/user-login.html',
      controller: function($scope, $log) {
        $scope.loginData = {};
        return $scope.userLogin = function(data) {
          return socket.emit('user-login', data);
        };
      }
    };
  });

  app.directive('createUser', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/create-user.html',
      controller: function($scope, $log) {
        $scope.createUserData = {};
        return $scope.createUser = function(data) {
          $log.info(data);
          return socket.emit('create-user', data);
        };
      }
    };
  });

  app.directive('navBar', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/nav-bar.html',
      controller: function($scope, $location, $log) {
        $scope.path = $location.path();
        $scope.$on('$locationChangeStart', function(event, next, current) {
          return $scope.path = next.split('#')[1];
        });
        return $scope.navData = [
          {
            label: 'Websites',
            link: '/websites'
          }, {
            label: 'Pages',
            link: '/pages'
          }, {
            label: 'Menus',
            link: '/menus'
          }, {
            label: 'Content Groups',
            link: '/content-groups'
          }, {
            label: 'Locales',
            link: '/locales'
          }, {
            label: 'Users',
            link: '/users'
          }
        ];
      }
    };
  });

  app.directive('usersOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/users-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.users = globalModel.getUsers();
        return socket.on('users-update', function(data) {
          return $scope.$apply(function() {
            return $scope.users = data;
          });
        });
      }
    };
  });

  app.directive('contentGroupsOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/content-groups-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.contentGroups = globalModel.getContentGroups();
        return socket.on('content-groups-update', function(data) {
          return $scope.$apply(function() {
            return $scope.contentGroups = data;
          });
        });
      }
    };
  });

  app.directive('localesOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/locales-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.locales = globalModel.getLocales();
        return socket.on('locales-update', function(data) {
          return $scope.$apply(function() {
            return $scope.locales = data;
          });
        });
      }
    };
  });

  app.directive('menusOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/menus-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.menus = globalModel.getMenus();
        return socket.on('menus-update', function(data) {
          return $scope.$apply(function() {
            return $scope.menus = data;
          });
        });
      }
    };
  });

  app.directive('pagesOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/pages-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.pages = globalModel.getPages();
        return socket.on('pages-update', function(data) {
          return $scope.$apply(function() {
            return $scope.pages = data;
          });
        });
      }
    };
  });

  app.directive('websitesOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/websites-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.websites = globalModel.getWebsites();
        return socket.on('websites-update', function(data) {
          return $scope.$apply(function() {
            return $scope.websites = data;
          });
        });
      }
    };
  });

  app.config(function($routeProvider) {
    var path;
    path = $routeProvider.when;
    path('/', {
      templateUrl: '/partials/home.html',
      controller: 'HomeController'
    });
    path('/websites', {
      templateUrl: '/partials/websites.html',
      controller: 'WebsitesController'
    });
    path('/pages', {
      templateUrl: '/partials/pages.html',
      controller: 'PagesController'
    });
    path('/menus', {
      templateUrl: '/partials/menus.html',
      controller: 'MenusController'
    });
    path('/content-groups', {
      templateUrl: '/partials/content-groups.html',
      controller: 'ContentGroupsController'
    });
    path('/locales', {
      templateUrl: '/partials/locales.html',
      controller: 'LocalesController'
    });
    return path('/users', {
      templateUrl: '/partials/users.html',
      controller: 'UsersController'
    });
  });

  app.controller('HomeController', function($scope, $modal, $log) {});

  app.controller('WebsitesController', function($scope, $modal, $log) {
    socket.emit('get-websites');
    return $scope.showCreateWebsite = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-website',
        controller: 'CreateWebsiteController'
      });
    };
  });

  app.controller('CreateWebsiteController', function($scope, $modalInstance, $log) {
    $scope.createWebsite = function(data) {
      socket.emit('create-website', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('PagesController', function($scope, $modal, $log) {
    socket.emit('get-pages');
    return $scope.showCreatePage = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-page',
        controller: 'CreatePageController'
      });
    };
  });

  app.controller('CreatePageController', function($scope, $modalInstance, $log) {
    $scope.createPage = function(data) {
      socket.emit('create-page', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('MenusController', function($scope, $modal, $log) {
    socket.emit('get-menus');
    return $scope.showCreateMenu = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-menu',
        controller: 'CreateMenuController'
      });
    };
  });

  app.controller('CreateMenuController', function($scope, $modalInstance, $log) {
    $scope.createMenu = function(data) {
      socket.emit('create-menu', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('ContentGroupsController', function($scope, $modal, $log) {
    socket.emit('get-content-groups');
    return $scope.showCreateContentGroup = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-content-group',
        controller: 'CreateContentGroupController'
      });
    };
  });

  app.controller('CreateContentGroupController', function($scope, $modalInstance, $log) {
    $scope.createContentGroup = function(data) {
      socket.emit('create-content-group', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('LocalesController', function($scope, $modal, $log) {
    socket.emit('get-locales');
    return $scope.showCreateLocale = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-locale',
        controller: 'CreateLocaleController'
      });
    };
  });

  app.controller('CreateLocaleController', function($scope, $modalInstance, $log) {
    $scope.createLocale = function(data) {
      socket.emit('create-locale', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('UsersController', function($scope, $modal, $log) {
    socket.emit('get-users');
    return $scope.showCreateUser = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-user',
        controller: 'CreateUserController'
      });
    };
  });

  app.controller('CreateUserController', function($scope, $modalInstance, $log) {
    $scope.createUserData = {};
    $scope.createUser = function(data) {
      socket.emit('create-user', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

}).call(this);
