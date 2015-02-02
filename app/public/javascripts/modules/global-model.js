(function() {
  var app, socket;

  socket = io();

  app = angular.module('global-model', []);

  app.factory('globalModel', function(sortByName) {
    var getFromId, getFromSlug, model;
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
    getFromSlug = function(arr, slug) {
      var l;
      l = arr.length;
      while (l--) {
        if (arr[l].slug === slug) {
          return arr[l];
        }
      }
    };
    getFromId = function(arr, id) {
      var l;
      l = arr.length;
      while (l--) {
        if (arr[l]._id === id) {
          return arr[l];
        }
      }
    };
    socket.on('websites-update', function(data) {
      data.map(function(site) {
        if (site.contentGroups) {
          site.contentGroups.sort(sortByName);
        }
        if (site.regions) {
          return site.regions.sort(sortByName);
        }
      });
      if (data) {
        return model.websites = data.sort(sortByName);
      }
    });
    socket.on('content-groups-update', function(data) {
      return model.contentGroups = data.sort(sortByName);
    });
    socket.on('regions-update', function(data) {
      data.map(function(region) {
        if (region.languages) {
          return region.languages.sort(sortByName);
        }
      });
      if (data) {
        return model.regions = data.sort(sortByName);
      }
    });
    socket.on('languages-update', function(data) {
      if (data) {
        return model.languages = data.sort(sortByName);
      }
    });
    socket.on('menus-update', function(data) {
      if (data) {
        return model.menus = data.sort(sortByName);
      }
    });
    socket.on('pages-update', function(data) {
      if (data) {
        return model.pages = data.sort(sortByName);
      }
    });
    socket.on('users-update', function(data) {
      return model.users = data;
    });
    return {
      getRecentActivity: function() {
        return [
          {
            name: 'test',
            slug: 'test'
          }
        ];
      },
      getWebsite: function(id) {
        return getFromId(model.websites, id);
      },
      getWebsiteBySlug: function(slug) {
        return getFromSlug(model.websites, slug);
      },
      getContentGroup: function(id) {
        return getFromId(model.contentGroups, id);
      },
      getContentGroupBySlug: function(slug) {
        return getFromSlug(model.contentGroups, slug);
      },
      getRegion: function(id) {
        return getFromId(model.regions, id);
      },
      getRegionBySlug: function(slug) {
        return getFromSlug(model.regions, slug);
      },
      getLanguage: function(id) {
        return getFromId(model.languages, id);
      },
      getLanguageBySlug: function(slug) {
        return getFromSlug(model.languages, slug);
      },
      getMenu: function(id) {
        return getFromId(model.menus, id);
      },
      getMenuBySlug: function(slug) {
        return getFromSlug(model.menus, slug);
      },
      getPage: function(id) {
        return getFromId(model.pages, id);
      },
      getPageBySlug: function(slug) {
        console.log(model.pages);
        return getFromSlug(model.pages, slug);
      },
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

}).call(this);
