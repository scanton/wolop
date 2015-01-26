(function() {
  var app, socket, sortByName;

  sortByName = function(a, b) {
    if (a.name > b.name) {
      return 1;
    }
    if (a.name < b.name) {
      return -1;
    }
    return 0;
  };

  socket = io();

  app = angular.module('wolop-cms', ['ngRoute', 'ui.bootstrap', 'ui.ace', 'chat']);

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

  app.factory('globalModel', function() {
    var model;
    model = {
      websites: [],
      contentGroups: [],
      regions: [],
      languages: [],
      menus: [],
      pages: [],
      users: [],
      peers: [],
      messages: []
    };
    socket.on('websites-update', function(data) {
      data.map(function(site) {
        site.contentGroups.sort(sortByName);
        return site.regions.sort(sortByName);
      });
      return model.websites = data.sort(sortByName);
    });
    socket.on('content-groups-update', function(data) {
      return model.contentGroups = data.sort(sortByName);
    });
    socket.on('regions-update', function(data) {
      return model.regions = data.sort(sortByName);
    });
    socket.on('languages-update', function(data) {
      return model.languages = data.sort(sortByName);
    });
    socket.on('menus-update', function(data) {
      return model.menus = data.sort(sortByName);
    });
    socket.on('pages-update', function(data) {
      return model.pages = data.sort(sortByName);
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
      getRegions: function() {
        return model.regions;
      },
      getLanguages: function() {
        return model.languages;
      },
      getMenus: function() {
        return model.menus;
      },
      getPages: function() {
        return model.pages;
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
            label: 'Products',
            link: '/products'
          }, {
            label: 'Static Text',
            link: '/static-text'
          }, {
            label: 'Regions',
            link: '/regions'
          }, {
            label: 'Languages',
            link: '/languages'
          }, {
            label: 'Users',
            link: '/users'
          }, {
            label: 'Notices',
            link: '/notices'
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
            return $scope.contentGroups = data.sort(sortByName);
          });
        });
      }
    };
  });

  app.directive('regionsOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/regions-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.regions = globalModel.getRegions();
        return socket.on('regions-update', function(data) {
          return $scope.$apply(function() {
            return $scope.regions = data.sort(sortByName);
          });
        });
      }
    };
  });

  app.directive('languagesOverview', function() {
    return {
      restrict: 'E',
      templateUrl: '/partials/directives/languages-overview.html',
      controller: function($scope, globalModel, $log) {
        $scope.languages = globalModel.getLanguages();
        return socket.on('languages-update', function(data) {
          return $scope.$apply(function() {
            return $scope.languages = data.sort(sortByName);
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
            return $scope.menus = data.sort(sortByName);
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
            return $scope.pages = data.sort(sortByName);
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
            data.map(function(site) {
              site.contentGroups.sort(sortByName);
              return site.regions.sort(sortByName);
            });
            return $scope.websites = data.sort(sortByName);
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
    path('/website/:slug', {
      templateUrl: '/partials/website-details.html',
      controller: 'WebsiteDetailsController'
    });
    path('/website/:site/content-group/:group', {
      templateUrl: '/partials/website-content-group-details.html',
      controller: 'WebsiteContentGroupDetailsController'
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
    path('/regions', {
      templateUrl: '/partials/regions.html',
      controller: 'RegionsController'
    });
    path('/languages', {
      templateUrl: '/partials/languages.html',
      controller: 'LanguagesController'
    });
    return path('/users', {
      templateUrl: '/partials/users.html',
      controller: 'UsersController'
    });
  });

  app.controller('HomeController', function($scope, $modal, $log) {});

  app.controller('WebsitesController', function($scope, $modal, $log) {
    $scope.addContentGroup = function(slug) {
      $scope.addContentGroupData = {
        website: slug
      };
      return $modal.open({
        templateUrl: '/partials/forms/add-content-group',
        controller: 'AddContentGroupController',
        scope: $scope
      });
    };
    $scope.addRegion = function(slug) {
      $scope.addRegionData = {
        website: slug
      };
      return $modal.open({
        templateUrl: '/partials/forms/add-region',
        controller: 'AddRegionController',
        scope: $scope
      });
    };
    return $scope.showCreateWebsite = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-website',
        controller: 'CreateWebsiteController'
      });
    };
  });

  app.controller('WebsiteDetailsController', function($scope, $routeParams, $log) {
    var index;
    index = $routeParams.slug;
    $scope.index = index;
    return socket.emit('working-on', index);
  });

  app.controller('WebsiteContentGroupDetailsController', function($scope, $routeParams, $log) {
    var group, site;
    site = $routeParams.site;
    group = $routeParams.group;
    socket.emit('working-on', site + ' (' + group + ')');
    return $scope.params = $routeParams;
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

  app.controller('AddContentGroupController', function($scope, $modalInstance, $log) {
    $scope.addContentGroup = function(data) {
      socket.emit('add-content-group', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('AddRegionController', function($scope, $modalInstance, $log) {
    $scope.addRegion = function(data) {
      socket.emit('add-region', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('RegionsController', function($scope, $modal, $log) {
    return $scope.showCreateRegion = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-region',
        controller: 'CreateRegionController'
      });
    };
  });

  app.controller('CreateRegionController', function($scope, $modalInstance, $log) {
    $scope.createRegion = function(data) {
      socket.emit('create-region', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('AddLanguageController', function($scope, $modalInstance, $log) {
    $scope.addLanguage = function(data) {
      socket.emit('add-language', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('LanguagesController', function($scope, $modal, $log) {
    return $scope.showCreateLanguage = function() {
      return $modal.open({
        templateUrl: '/partials/forms/create-language',
        controller: 'CreateLanguageController'
      });
    };
  });

  app.controller('CreateLanguageController', function($scope, $modalInstance, $log) {
    $scope.createLanguage = function(data) {
      socket.emit('create-language', data);
      return $modalInstance.dismiss('form-sumbit');
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss('cancel');
    };
  });

  app.controller('UsersController', function($scope, $modal, $log) {
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
