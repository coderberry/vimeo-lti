var SearchView = Ember.View.extend({
  didInsertElement: function() {
    var view = this;
    $(window).bind("scroll", function() {
      view.didScroll();
    });
  },

  willDestroyElement: function() {
    $(window).unbind("scroll");
  },

  didScroll: function() {
    if(this.isScrolledToBottom()) {
      this.get('controller').send('more');
    }
  },

  isScrolledToBottom: function() {
    var distanceToTop = $(document).height() - $(window).height(),
        top           = $(document).scrollTop();

    return top === distanceToTop;
  }
});

module.exports = SearchView;

