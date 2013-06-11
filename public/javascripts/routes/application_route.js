var ApplicationRoute = Ember.Route.extend({
  events: {
    search: function() {
      var q = this.controllerFor('application').get('q');
      this.transitionTo('search', {q: q});
    }
  }
});

module.exports = ApplicationRoute;
