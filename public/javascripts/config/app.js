require('../vendor/jquery');
require('../vendor/handlebars');
require('../vendor/ember');
require('../vendor/ember-data'); // delete if you don't want ember-data
// require('../vendor/moment');

var App = Ember.Application.create({ LOG_TRANSITIONS: true });
App.Store = require('./store'); // delete if you don't want ember-data

App.sortFilters = [
  Ember.Object.create({ id: 'relevant', name: 'Relevant' }),
  Ember.Object.create({ id: 'newest', name: 'Newest' }),
  Ember.Object.create({ id: 'oldest', name: 'Oldest' }),
  Ember.Object.create({ id: 'most_played', name: 'Most Played' }),
  Ember.Object.create({ id: 'most_commented', name: 'Most Comments' }),
  Ember.Object.create({ id: 'most_liked', name: 'Most Liked' })
]
App.currentSortFilter = Ember.Object.create({ id: 'relevant' })

module.exports = App;

