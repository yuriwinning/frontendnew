// TODO: Implement an `add` method for push notifications
// TODO: Add ability to accept/decline invitations versus just dismisal.
Radium.NotificationsController = Ember.ArrayController.extend({
  dismiss: function(event) {
    this.get('content').removeObject(event.view.content);
    return false;
  },
  bootstrapLoaded: function(){
    debugger;
    this.set('content',  Radium.getPath('appController.notifications'));
  }.observes('Radium.appController.notifications')
});
