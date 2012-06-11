Radium.OverdueActivitiesController = Ember.ArrayController.extend({
  bootstrapLoaded: function() {
    var feed = Radium.getPath('appController.overdue_feed'),
        ids = feed.getEach('id');

    feed.forEach(function(item){
      var activity = item,
          kind = activity.kind,
          model = Radium[Radium.Utils.stringToModel(kind)],
          reference = activity.reference[kind];

      activity[kind] = reference;
      // Radium.store.load(model, reference);
    });

    if(!feed.length || feed.length === 0){
      this.set('content', []);
      return;
    }

    Radium.store.loadMany(Radium.Activity, feed);
    this.set('content', Radium.store.findMany(Radium.Activity, ids));

  }.observes('Radium.appController.overdue_feed')
});