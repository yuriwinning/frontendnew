Radium.AppController = Ember.Object.extend({
  sideBarView: null,
  feedView: null,
  // During development set to true
  isLoggedIn: true,
  // Store the routes intercepted by Davis
  _statePathCache: {},
  currentPage: null,
  selectedForm: null,
  params: null,
  account: null,
  createDataStoreWorker: function(activities){
    var worker = new Worker('worker.js');

    worker.addEventListener('message', function(e){
      Radium.store.loadMany(Radium.Activity, e.data);
      worker.terminate();
    });

    worker.addEventListener('error', function(e){
      Radium.store.loadMany(Radium.Activity, activities);
      worker.terminate();
    });

    worker.postMessage(activities);
  },
  bootstrap: function(data){
    if(Radium.Utils.browserSupportsWeb()){
      this.createDataStoreWorker(data.feed.activities);
    }else{  
      Radium.store.loadMany(Radium.Activity, activities);
    }

    Radium.store.load(Radium.Account, data.account);
    var account = Radium.store.find(Radium.Account, data.account.id),
        clusters = [];

    //kick off observers
    this.set('account', account);
    this.set('users', data.users);
    this.set('current_user', data.current_user);
    this.set('overdue_feed', data.overdue_activities);
    this.set('clusters', data.feed.clusters.map(function(data) { return Ember.Object.create(data); }));
    this.set('contacts', data.contacts);

    Radium.get('activityFeedController').bootstrapLoaded();
  },

  today: Ember.DateTime.create({hour: 17, minute: 0, second: 0}),
  todayString: function() {
    return this.get('today').toFormattedString("%Y-%m-%d");
  }.property('today').cacheable()
});
