var SearchView = Ember.View.extend({
  didInsertElement: function() {
    var view = this;
    $(window).bind("scroll", function() {
      view.didScroll();
    });
  },

  didScroll: function() {
    // console.log(window.scrollY);
    // PaginatedCollectionView.coffee
  },

  fetchMore: function() {
    var model = this.get('controller.model');
    model.fetchMore();
  }
});

module.exports = SearchView;

