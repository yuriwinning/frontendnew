Radium.feedByDayController = Crossfilter.Dimension.create({
  _byDay: function(data) {
    return new Date(data.timestamp).getTime();
  },

  userFilterBinding: 'Radium.feedByUserController.filter',
  kindFilterBinding: 'Radium.feedByKindController.filter',

  loadedActivities: Ember.A([]),

  crossfilterDidChange: function() {
    var cf = this.get('crossfilter'),
        dimension = cf.dimension(this._byDay),
        group = dimension.group();

    this.setProperties({
      dimension: dimension,
      group: group
    });

    this.updateList();
  }.observes('crossfilter'),

  updateList: function() {
    var dimension = this.get('dimension'),
        pastActivities = dimension.top(Infinity).filterProperty('isNewActivity', false),
        pushedActivities = dimension.top(Infinity).filterProperty('isNewActivity', true),
        unCachedActivities = pastActivities.filterProperty('isCached', false),
        unCachedPushed = pushedActivities.filterProperty('isCached', false);

    if (unCachedActivities.length) {
      this.get('loadedActivities').pushObjects(unCachedActivities);
      unCachedActivities.setEach('isCached', true);
    }

    if (unCachedPushed.length) {
      this.get('loadedActivities').insertAt(0, unCachedPushed)
    }

    if (Ember.compare(this.get('loadedActivities'), dimension.top(Infinity)) !== 0) {
      this.set('loadedActivities', dimension.top(Infinity));
    }
  },

  refresh: function() {
    Ember.run.sync();
    this.updateList();
  }
});