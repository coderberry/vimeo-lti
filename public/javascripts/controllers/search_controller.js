var SearchController = Ember.ObjectController.extend({
  filters: function() {
    return App.SearchCriteria;
  }.property()
});

module.exports = SearchController;

