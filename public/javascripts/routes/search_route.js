var SearchRoute = Ember.Route.extend({

  setupController: function(controller, model) {
    this.controllerFor('application').set('q', model.q);
    controller.set('model', {
      q: model.q,
      videos: App.Video.findQuery({q: model.q})
    });
  },
  
  model: function(params) {
    return {q: decodeURIComponent(params.q)};
  },

  serialize: function() {
    return {
      q: encodeURIComponent(this.controllerFor('application').get('q'))
    };
  }
  
});

module.exports = SearchRoute;

