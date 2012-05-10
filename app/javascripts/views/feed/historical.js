Radium.HistoricalFeedView = Ember.View.extend({
  classNames: ['feed-item'],
  classNameBindings: [
    'content.kind',
    'content.isTodoFinished:finished'
  ],
  layoutName: 'historical_layout',
  defaultTemplate: 'default_activity',
  template: Ember.computed(function() {
    var kind = this.getPath('content.kind'),
        tag = this.getPath('content.tag'),
        templateName = [kind, tag].join('_'),
        template = this.templateForName(templateName, 'template');
    return template || this.get('defaultTemplate');
  }).property('content.kind', 'content.tag').cacheable(),

  iconView: Ember.View.extend({
    tagName: 'i',
    classNameBindings: [
      'todo:icon-check',
      'contact:icon-user',
      'email:icon-envelope'
    ],
    todo: function() {
      return this.getPath('parentView.content.kind') === 'todo';
    }.property('parentView.content.kind').cacheable(),
    contact: function() {
      return this.getPath('parentView.content.kind') === 'contact';
    }.property('parentView.content.kind').cacheable(),
    email: function() {
      return this.getPath('parentView.content.kind') === 'email';
    }.property('parentView.content.kind').cacheable(),
  }),

  isActionsVisible: false,

  toggleActionsView: Ember.View.extend({
    tagName: 'i',
    classNames: 'activity-action-btn'.w(),
    classNameBindings: [
      'isActionsVisible:icon-chevron-up',
      'isActionsNotVisible:icon-chevron-down'
    ],
    isActionsVisibleBinding: 'parentView.isActionsVisible',
    isActionsNotVisible: function() {
      return !this.get('isActionsVisible');
    }.property('isActionsVisible').cacheable(),
    click: function() {
      this.toggleProperty('isActionsVisible');
    }
  }),

  // Comments
  commentsView: null,

  isCommentsVisible: false,

  commentsView: null,
  
  toggleComments: function() {
    console.log(this.get('isActionsVisible'));
    if (this.get('isActionsVisible')) {
      var activity = this.get('content'),
        commentsController = Radium.inlineCommentsController.create({
          activity: activity,
          contentBinding: 'activity.comments'
        }),
        commentsView = Radium.InlineCommentsView.create({
          controller: commentsController,
          contentBinding: 'controller.content'
        });
    this.set('commentsView', commentsView);
    commentsView.appendTo(this.$());

    } else {
      if (this.get('commentsView')) {
        this.get('commentsView').remove();
        this.set('commentsView', null);
      }      
    }
  }.observes('isActionsVisible')
});