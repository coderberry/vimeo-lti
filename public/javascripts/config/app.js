require('../vendor/jquery');
require('../vendor/handlebars');
require('../vendor/ember');

var App = Ember.Application.create({ LOG_TRANSITIONS: true });

App.SearchCriteria = Ember.ArrayProxy.create({
  content: [
    Ember.Object.create({ isSelected: true,  id: 'relevant',       name: 'Relevant' }),
    Ember.Object.create({ isSelected: false, id: 'newest',         name: 'Newest'   }),
    Ember.Object.create({ isSelected: false, id: 'most_played',    name: 'Popular'  }),
    Ember.Object.create({ isSelected: false, id: 'most_commented', name: 'Comments' }),
    Ember.Object.create({ isSelected: false, id: 'most_liked',     name: 'Likes'    })
  ],
  page: '1',
  q: '',
  setActiveFilter: function(filterId) {
    this.forEach(function(item, index, enumerable) {
      item.set('isSelected', false);
      if (item.get('id') == filterId) {
        item.set('isSelected', true);
      }
    });
    return this.getActiveFilter();
  },
  getActiveFilter: function() {
    var activeItem =  this.find(function(item, index, enumerable) {
      if (item.get('isSelected')) {
        return item;
      }
    });
    if (activeItem) {
      return activeItem.get('id');
    } else {
      return this.setActiveFilter('relevant');
    }
  }
});

module.exports = App;

