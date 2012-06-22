Radium.FeedFilterItemView = Ember.View.extend({
  tagName: 'li',
  templateName: 'filter',
  classNames: ['main-filter-item'],
  classNameBindings: ['isSelected:active'],
  isSelected: function() {
    return (this.getPath('parentView.filter') == this.getPath('content.kind')) ? true : false;
  }.property('parentView.filter').cacheable(),
  
  // Actions
  setFilter: function(event) {
    var kind = this.getPath('content.kind');
    var speed = 'fast';

    this.setPath('parentView.filter', kind);

    var types = $('.meeting,.todo,.deal,.call_list,.campaign,.contact');

    if(!kind){
      types.slideDown(speed);
      return false;
    }

    var className = '.' + kind;

    $(types).not(className).slideUp(speed, function(){
      $(className).slideDown(speed);
    });
    
    return false;
  },
  addResourceButton: Ember.View.extend({
    classNames: 'icon-plus'.w(),
    tagName: 'i',
    attributeBindings: ['title'],
    singular: {
      'Companies': 'Company'
    },
    title: function() {
      var type = this.getPath('parentView.content.label');
      return "Add a new " + type.substr(0, type.length-1);
    }.property(),
    click: function(event) {
      var $sender = $(event.target),
          kind = this.getPath('parentView.content.label'),
          formType = (this.singular[kind]) 
                    ? this.singular[kind] 
                    : kind.replace(' ', '').slice(0, -1);

      Radium.FormContainerView['show' + formType + 'Form']();
      return false;
    }
  }),
  iconView: Radium.SmallIconView,

  badge: Ember.View.extend({
    tagName: 'span',
    classNames: ['pull-right'],
    template: Ember.Handlebars.compile('<span class="badge">{{count}}</span>')
  })
});
