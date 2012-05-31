Radium.EndlessScrolling = Ember.Mixin.create({

  didInsertElement: function() {
    this._super();
    this.loadFeed();
  },

  willDestroyElement: function() {
    $(window).off('scroll');
  },

  infiniteLoading: function() {
    if ($(window).scrollTop() > $(document).height() - $(window).height() - 300) {
      this.loadFeed();
      return false;
    }
  },

  noData: false,

  isLoadingObserver: function() {
    var self = this;
    if (this.getPath('controller.isLoading')) {
      $(window).off('scroll');
    } else {
      $(window).on('scroll', $.proxy(self.infiniteLoading, self));
    }
  }.observes('controller.isLoading'),

  loadFeed: function() {
    //TODO: Check with Josh, in contact.show action, the ContactPageView.
    //uses has no controller.  loadDates is in the feedController
    if(!this.get('controller'))
      return;

    this.get('controller').loadDates();
  }
});
