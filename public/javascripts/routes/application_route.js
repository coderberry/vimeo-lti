var ApplicationRoute = Ember.Route.extend({
  events: {
    search: function() {
      var q = this.controllerFor('application').get('q');
      if (q.length > 0) {
        this.transitionTo('search', {q: q});  
      } else {
        this.transitionTo('index');
      }
    }
  }
});

module.exports = ApplicationRoute;
