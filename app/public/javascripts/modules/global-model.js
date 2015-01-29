(function() {
  var app, socket;

  socket = io();

  app = angular.module('global-model', []);

  app.factory('globalModel', function(sortByName) {
    var getFromSlug, model;
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
      getWebsiteBySlug: function(slug) {
        return getFromSlug(model.websites, slug);
      },
      getContentGroupBySlug: function(slug) {
        return getFromSlug(model.contentGroups, slug);
      },
      getRegionBySlug: function(slug) {
        return getFromSlug(model.regions, slug);
      },
      getLanguageBySlug: function(slug) {
        return getFromSlug(model.languages, slug);
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
      },
      getRegion: function(id) {
        var l;
        l = model.regions.length;
        while (l--) {
          if (model.regions[l]._id === id) {
            return model.regions[l];
          }
        }
      }
    };
  });

}).call(this);
