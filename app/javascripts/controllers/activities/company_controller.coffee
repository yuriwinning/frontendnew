Radium.ActivitiesCompanyController = Radium.ObjectController.extend
  isCreate: Ember.computed.is 'event', 'create'
  isUpdate: Ember.computed.is 'event', 'update'
  isAssign: Ember.computed.is 'event', 'assign'

  company: Ember.computed.alias 'reference'
  assignedTo: Ember.computed.alias 'meta.user'
