var Video = Ember.Object.extend({
  isLoaded: false,
  currentPage: 1,

  oembed: function() {
    var model = this;
    $.getJSON('/api/video/' + this.get('id') + '/oembed', function(oembedRes) {
      model.set('oembed', oembedRes);
    });
  }.property()
});

Video.reopenClass({

  models: Ember.ArrayProxy.create({content: []}),
  isLoading: false,
  resultSets: {},

  findQuery: function(params) {

    params.sort = App.currentSortFilter.id

    var queryId = parameterize(params);
    if (this.resultSets[queryId]) {
      return this.resultSets[queryId];
    }

    console.log(params)
    console.log(App.currentSortFilter)

    var results = this.fetchQuery(params);
    this.resultSets[queryId] = results;
    return results;
  },

  find: function(id) {
    var cached = this.models.findProperty('id', id);
    if (cached && cached.get('oembed')) {
      return cached;
    } else {
      return this.fetchOne(id);
    }
  },

  fetchQuery: function(params) {
    var results = Ember.ArrayProxy.create({isLoaded: false, content: []});
    $.getJSON('/api/search', params, function(res) {
      for (var i = 0, l = res.length; i < l; i++) {
        var model = this.models.findProperty('id', res[i].id);
        if (!model) model = this.createRecord(res[i]);
        model.set('isLoaded', true);
        results.addObject(model);
      }
      results.set('isLoaded', true);
    }.bind(this));
    return results;
  },

  fetchOne: function(id) {
    var model = this.createRecord({id: id});
    $.getJSON('/api/video/' + id, function(res) {
      delete res.id;
      model.setProperties(res);
      model.set('isLoaded', true);
    });
    return model;
  },

  createRecord: function(properties) {
    var model = this.create(properties);
    this.models.addObject(model);
    return model;
  },

  fetchMore: function() {
    var params = { }
    $.getJSON('/api/search', params, function(res) {
      for (var i = 0, l = res.length; i < l; i++) {
        var model = this.models.findProperty('id', res[i].id);
        if (!model) model = this.createRecord(res[i]);
        model.set('isLoaded', true);
        results.addObject(model);
      }
    }.bind(this));
  }

});

function parameterize(params) {
  var query = [];
  for (var key in params) {
    query.push(key + '=' + params[key]);
  }
  return query.join('&');
}

module.exports = Video;
