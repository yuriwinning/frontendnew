Radium.Settings = DS.Model.extend
  negotiatingStatuses: DS.attr('array')
  # FIXME: Should there be a user's setting object
  # that is separate from the global settings?
  signature: DS.attr('string')
  checklist: DS.belongsTo('Radium.Checklist')
  dealSources: DS.attr('array')
  companyName: DS.attr('string')
  companyAvatar: DS.attr('object')
  currentPlan: DS.attr('string')
  customFields: DS.attr('array')
  reminders: DS.belongsTo('Radium.NotificationSettings')