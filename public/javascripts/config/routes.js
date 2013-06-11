var App = require('./app');

App.Router.map(function() {
  this.resource('search', {path: '/search/:q'});
  this.resource('video', {path: '/videos/:video_id'});
});

