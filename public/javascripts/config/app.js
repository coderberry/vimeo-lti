require('../vendor/jquery');
require('../vendor/handlebars');
require('../vendor/ember');
require('../vendor/ember-data'); // delete if you don't want ember-data
require('../vendor/moment');

var App = Ember.Application.create({ LOG_TRANSITIONS: true });
App.Store = require('./store'); // delete if you don't want ember-data

module.exports = App;

