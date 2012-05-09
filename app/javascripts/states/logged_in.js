var topBarView = Radium.TopbarView.create();
Radium.LoggedIn = Ember.State.create({
  enter: function() {
    $('#main-nav').show();
    topBarView.appendTo('#topbar');
  },
  exit: function() {
    topBarView.remove();
  },
  start: Ember.ViewState.create({
    view: Radium.LoadingView,
    start: Ember.State.create({
      enter: function(manager) {
        var groups = Radium.store.find(Radium.Group, {page: 'all'});
        // contacts = Radium.store.find(Radium.Contact, {page: 0}),
        
        groups.addObserver('isLoaded', function() {
          Radium.groupsController.set('content', groups);
        });
        Ember.run.next(function() {
          manager.goToState(Radium.appController.getPath('_statePathCache'));
        });
        // contacts.addObserver('isLoaded', function() {
        //   Radium.contactsController.set('content', contacts);
        //   Ember.run.next(function() {
        //     manager.goToState(Radium.appController.getPath('_statePathCache'));
        //   });
        // });

      }
    })
  }),
  dashboard: Radium.DashboardPage.create(),
  contacts: Radium.ContactsPage.create(),
  users: Radium.UsersPage.create(),
  deals: Radium.DealsPage.create(),
  pipeline: Radium.PipelinePage.create(),
  campaigns: Radium.CampaignsPage.create(),
  calendar: Ember.State.create({}),
  messages: Ember.State.create({}),
  settings: Ember.State.create({}),
  noData: Ember.ViewState.create({
    view: Ember.View.extend({
      templateName: 'error_page'
    })
  }),

  // Actions
  logout: function(manager, context) {
    manager.goToState('loggedOut');
  }
});