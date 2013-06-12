var VideoRoute = Ember.Route.extend({
  model: function(params) {
    return App.Video.find(params.video_id);
  }

  // events: {
  //   chooseVideoLink: function(event) {
  //     debugger
  //     return "/api/choose/" + this.get('id');
  //   }
  // }
});

module.exports = VideoRoute;
