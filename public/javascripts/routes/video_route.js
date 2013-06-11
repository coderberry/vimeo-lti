var VideoRoute = Ember.Route.extend({
  model: function(params) {
    return App.Video.find(params.video_id);
  }
});

module.exports = VideoRoute;

