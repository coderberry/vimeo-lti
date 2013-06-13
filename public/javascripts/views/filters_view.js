var FiltersView = Ember.View.extend({
  tagName: 'ul',
  classNameBindings: ['isEnabled::disabled'],
  classNames: ['nav', 'nav-pills'],
  templateName: 'filters',
  isEnabled: false
});

module.exports = FiltersView;

