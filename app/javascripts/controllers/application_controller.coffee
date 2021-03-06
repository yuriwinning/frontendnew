Radium.ApplicationController = Radium.ObjectController.extend
  actions:
    transitionToList: (list) ->
      @EventBus.publish 'closeDrawers'

      @transitionToRoute 'list', list

      false

  needs: ['notifications']
  isSidebarVisible: false
  today: Ember.DateTime.create()
  notificationCount: 0
  title: 'Radium'

  showNotifications: false

  titleChanged: Ember.observer 'notificationCount', ->
    title = @get('title')
    notificationCount = @get('notificationCount')

    if notificationCount
      title = "(#{notificationCount}) #{title}"

    window.setTimeout ->
      document.title = "."
      document.title = title
    , 200

  notifications: Ember.computed.oneWay 'controllers.notifications'
