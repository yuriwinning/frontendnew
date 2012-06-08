  // classNames: ['historical'],
  // classNameBindings: [
  //   'content.kind',
  //   'content.isTodoFinished:finished',
  //   'isActionsVisible:expanded',
  // ],
  // isActionsVisible: false,
  // layoutName: 'historical_layout',
  // defaultTemplate: 'default_activity',
  // init: function() {
  //   this._super();
  //   var kind = this.getPath('content.kind'),
  //       tag = this.getPath('content.tag'),
  //       templateName = [kind, tag].join('_');

  //   this.set('templateName', templateName);
  // }
Radium.FeedHeaderView = Ember.View.extend({
  contentBinding: 'parentView.content',
  classNames: 'feed-header span9'.w(),
  attributeBindings: ['title'],
  titleBinding: Ember.Binding.oneWay('content.id'),
  layoutName: 'historical_layout',
  isActionsVisibleBinding: 'parentView.isActionsVisible',
  click: function(event) {
    event.stopPropagation();
    this.toggleProperty('isActionsVisible');
  },
  init: function() {
    this._super();
    var kind = this.getPath('content.kind'),
        tag = this.getPath('content.tag'),
        templateName = [kind, tag].join('_');
    this.set('templateName', templateName);
  }
});

Radium.HistoricalFeedView = Ember.ContainerView.extend({
  classNames: ['row'],
  classNameBindings: ['isActionsVisible:expanded'],
  isActionsVisible: false,
  init: function() {
    this._super();
    var content = this.get('content');
    // Set up the main row header
    this.set('currentView', Radium.FeedHeaderView.create({
      content: content
    }));
    // Add a commentsView
   var commentsView = Radium.InlineCommentsView.create({
        controller: Radium.inlineCommentsController.create({
          activity: content,
          contentBinding: 'activity.comments'
        }),
        contentBinding: 'controller.content'
      });
    this.set('commentsView', commentsView);
  },
  commentsVisibilityDidChange: function() {
    var self = this,
          childViews = this.get('childViews'),
          commentsView = this.get('commentsView');
    if (this.get('isActionsVisible')) {
      childViews.pushObject(commentsView);
    } else if (childViews.get('length')) {
      $.when(commentsView.slideUp())
        .then(function() {
          childViews.removeObject(commentsView);
          self.setPath('parentView.isEditMode', false);
        });
    }
  }.observes('isActionsVisible')
});