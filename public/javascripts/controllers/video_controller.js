var VideoController = Ember.ObjectController.extend({
  thumbnail: function() {
    var thumbs = this.get('model.thumbnails.thumbnail');
    if (thumbs.length > 1) {
      return thumbs[1]._content;
    } else {
      return '__DEFAULT__THUMBNAIL_MISSING_';
    }
  }.property('model.thumbnails.thumbnail'),

  userPic: function() {
    var pics = this.get('model.owner.portraits.portrait');
    if (pics.length > 0) {
      return pics[0]._content;
    } else {
      return '__DEFAULT__THUMBNAIL_MISSING_';
    }
  }.property('model.owner.portraits.portrait'),

  userName: function() {
    return this.get('model.owner.username')
  }.property('model.owner.username'),

  userUrl: function() {
    return this.get('model.owner.videosurl')
  }.property('model.owner.videosurl'),

  minutes: function() {
    return this.secondsToDisplayMinutes(this.get('duration'))
  }.property('model.duration'),


  addedTimeAgo: function() {
    // 2013-06-06 13:56:38
    moment(this.get('model.upload_date'), 'YYYY-MM-DD HH:mm:ss').fromNow()
  }.property('model.upload_date'),

  padNumber: function(num) {
    if (num < 10) {
      return '0' + num;
    } else {
      return num;
    }
  },

  secondsToDisplayMinutes: function(seconds) {
    minVar = Math.floor(seconds/60);
    secVar = seconds % 60;
    return this.padNumber(minVar) + ":" + this.padNumber(secVar);
  }
});

module.exports = VideoController;

