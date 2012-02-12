define('views/filter_list', function(require) {
  
  require('ember');
  var Radium = require('radium');
  require('controllers/resources');
  
  var template = require('text!templates/filter_list.handlebars');
  
  Radium.ActivityFilterList = Ember.CollectionView.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked'.w(),
    contentBinding: 'Radium.resourcesController.content',
    itemViewClass: Ember.View.extend({
      categoryFilterBinding: 'Radium.dashboardController.categoryFilter',
      isEnabled: function() {
        return (this.get('categoryFilter') == this.getPath('content.shortname')) ? true : false;
      }.property('categoryFilter').cacheable(),
      classNameBindings: ['isEnabled:active'],
      template: Ember.Handlebars.compile(template),
      changeFilter: function(event) {
        event.preventDefault();
        var type = this.getPath('content.shortname');
        Radium.dashboardController.set('categoryFilter', type);
        return false;
      },

      // The little + buttons
      addFormInlineView: Ember.View.extend({
        classNames: 'icon-plus',
        tagName: 'i',
        attributeBindings: ['title'],
        title: function() {
          var type = this.getPath('parentView.content.title');
          return "Add a new " + type.substr(0, type.length-1);
        }.property(),
        click: function(event) {
          var formType = this.getPath('parentView.content.formViewClass');
          Radium.App.send('loadForm', formType);
          event.stopPropagation();
          return false;
        }
      })
    })
  });
  
  return Radium;
});