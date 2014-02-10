Radium.ActivitiesMeetingController = Radium.ActivityBaseController.extend
  isReschedule: Ember.computed.is 'event', 'reschedule'
  isCancel: Ember.computed.is 'event', 'cancel'
  isCreate: Ember.computed.is 'event', 'create'
  isUpdate: Ember.computed.is 'event', 'update'

  meeting: Ember.computed.alias 'reference'
  participants: Ember.computed.alias 'reference.participants'
  newTime: Ember.computed.alias 'meta.time'

  icon: 'calendar'

  participants: Radium.computed.aggregate('meeting.users', 'meeting.contacts')

  eventName: (->
    switch @get('event')
      when 'cancel' then 'cancelled'
      else @get('event')
  ).property('event')
