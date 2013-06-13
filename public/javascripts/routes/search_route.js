var SearchRoute = Ember.Route.extend({

  isLoading: false,

  setupController: function(controller, model) {
    this.controllerFor('application').set('q', model.q);
    
    App.SearchCriteria.set('page', model.page);
    App.SearchCriteria.setActiveFilter(model.sort);
    App.SearchCriteria.set('q', model.q);

    controller.set('model', {
      q: model.q,
      sort: model.sort,
      page: model.page,
      videos: App.Video.findQuery(model)
    });
  },
  
  model: function(params) {
    rawParams = params.q;
    splitParams = rawParams.split('?');
    ret = { q: decodeURIComponent(splitParams[0]) };
    if (splitParams[1]) {
      keyValues = splitParams[1].split('&');

      $.each(keyValues, function(idx, keyValue) {
        var kv = keyValue.split('=');
        ret[kv[0]] = decodeURIComponent(kv[1]);
      });
    }
    if (!ret['sort']) { ret['sort'] = App.SearchCriteria.getActiveFilter() };
    if (!ret['page']) { ret['page'] = App.SearchCriteria.get('page') };

    return ret;
  },

  serialize: function() {
    return {
      q: encodeURIComponent(this.controllerFor('application').get('q'))
    };
  },
  
  events: {
    applyFilter: function(filter) {
      this.transitionTo('search', { 
        q:    App.SearchCriteria.get('q'), 
        page: App.SearchCriteria.get('page'), 
        sort: filter.get('id') 
      });
    },

    more: function() {
      console.log("pagination to come");
      // videos = this.controllerFor('search').get('model.videos')
    }
  }
  
});

module.exports = SearchRoute;
