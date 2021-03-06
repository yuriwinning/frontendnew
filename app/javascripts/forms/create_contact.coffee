Radium.CreateContact = Radium.Model.extend
  contact: DS.belongsTo('Radium.Contact')
  user: DS.belongsTo('Radium.User')

  name: DS.attr('string')
  title: DS.attr('string')
  website: DS.attr('string')
  companyName: DS.attr('string')
  contactStatus: DS.belongsTo('Radium.ContactStatus')
  source: DS.attr('string')
  about: DS.attr('string')
  isPublic: DS.attr('boolean', default: true)
  gender: DS.attr('string')
  fax: DS.attr('string')

  phoneNumbers: DS.attr('array')
  emailAddresses: DS.attr('array')
  addresses: DS.attr('array')
  lists: DS.attr('array', defaultValue: [])

  customFieldValues: DS.hasMany('Radium.CustomFieldValue')
