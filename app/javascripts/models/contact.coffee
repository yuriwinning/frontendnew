Radium.Contact = Radium.Model.extend Radium.HasTasksMixin,
  Radium.AttachmentsMixin,

  todos: DS.hasMany('Radium.Todo', inverse: '_referenceContact')
  meetings: DS.hasMany('Radium.Meeting', inverse: '_referenceContact')
  deals: DS.hasMany('Radium.Deal', inverse: 'contact')
  lists: DS.hasMany('Radium.List')
  activities: DS.hasMany('Radium.Activity', inverse: 'contacts')
  phoneNumbers: DS.hasMany('Radium.PhoneNumber')
  emailAddresses: DS.hasMany('Radium.EmailAddress')
  addresses: DS.hasMany('Radium.Address')
  notes: DS.hasMany('Radium.Note', inverse: '_referenceContact')

  nextMeeting: DS.belongsTo('Radium.Meeting', inverse: null)
  user: DS.belongsTo('Radium.User')
  company: DS.belongsTo('Radium.Company', inverse: 'contacts')

  contactInfo: DS.belongsTo('Radium.ContactInfo')

  contactImportJob: DS.belongsTo('Radium.ContactImportJob')

  contactStatus: DS.belongsTo('Radium.ContactStatus')

  customFieldValues: DS.hasMany('Radium.CustomFieldValue')
  name: DS.attr('string')
  companyName: DS.attr('string')
  source: DS.attr('string')
  title: DS.attr('string')
  avatarKey: DS.attr('string')
  about: DS.attr('string')
  removeCompany: DS.attr('boolean')
  updateStatus: DS.attr('string')
  lastActivityAt: DS.attr('datetime')
  activityTotal: DS.attr('number')
  nextTaskDate: DS.attr('datetime')
  website: DS.attr('string')
  fax: DS.attr('string')
  gender: DS.attr('string')

  nextTodo: DS.belongsTo('Radium.Todo', inverse: null)
  nextTask: Ember.computed 'nextTodo', 'nextMeeting', ->
    @get('nextTodo') || @get('nextMeeting')

  nextTaskDateDisplay: Ember.computed 'nextTaskDate', ->
    if @get('nextTaskDate')?
      @get('nextTaskDate').readableTimeAgo()

  daysInactive: Ember.computed 'lastActivityAt', ->
    if @get("lastActivityAt")?
      @get('lastActivityAt').readableTimeAgo()

  twitter: Ember.computed 'contactInfo.socialProfiles.[]', ->
    @get('contactInfo.socialProfiles')?.find (s) -> s.get('type') == 'twitter'

  facebook: Ember.computed 'contactInfo.socialProfiles.[]', ->
    @get('contactInfo.socialProfiles')?.find (s) -> s.get('type') == 'facefook'

  linkedin: Ember.computed 'contactInfo.socialProfiles.[]', ->
    @get('contactInfo.socialProfiles')?.find (s) -> s.get('type') == 'linkedin'

  isPublic: DS.attr('boolean')
  potentialShare: DS.attr('boolean')
  isPersonal: Ember.computed.not 'isPublic'

  ignored: DS.attr('boolean')
  archived: DS.attr('boolean')

  businessCardUrl: DS.attr('string')
  vcardUrl: DS.attr('string')
  activitySevenDaysTotal: DS.attr('number')
  activityThirtyDaysTotal: DS.attr('number')

  isExpired: Radium.computed.daysOld('createdAt', 60)

  latestDeal: Ember.computed 'deals', ->
    @get('deals.firstObject')

  tasks: Radium.computed.tasks('todos', 'meetings')

  notifications: DS.hasMany('Radium.Notification', inverse: '_referenceContact')

  primaryEmail: Radium.computed.primary 'emailAddresses'
  primaryPhone: Radium.computed.primary 'phoneNumbers'
  primaryAddress: Radium.computed.primary 'addresses'

  domain: Ember.computed 'primaryEmail', ->
    return unless primaryEmail = @get('primaryEmail.value')

    return unless primaryEmail.indexOf('@') > 0

    "@#{primaryEmail.split('@').pop()}"

  email: Radium.computed.primaryAccessor 'emailAddresses', 'value', 'primaryEmail'
  phone: Radium.computed.primaryAccessor 'phoneNumbers', 'value', 'primaryPhone'
  city: Radium.computed.primaryAccessor 'addresses', 'city', 'primaryAddress'
  street: Radium.computed.primaryAccessor 'addresses', 'street', 'primaryAddress'
  state: Radium.computed.primaryAccessor 'addresses', 'state', 'primaryAddress'
  zipcode: Radium.computed.primaryAccessor 'addresses', 'zipcode', 'primaryAddress'

  added: Ember.computed 'createdAt', ->
    @get('createdAt').toFormattedString("%B %d, %Y")

  openDeals: Ember.computed 'deals.[]', ->
    @get('deals').filterProperty 'isOpen'

  displayName: Ember.computed 'name', 'primaryEmail', 'primaryPhone', ->
    @get('name') || @get('primaryEmail.value') || @get('primaryPhone.value')

  nameWithEmail: Ember.computed 'name', 'primaryEmail', ->
    name = @get('name')
    email = @get('email')

    hasName = name?.length
    hasEmail = email?.length

    if hasName && not hasEmail
      return name

    if hasEmail && not hasName
      return email

    "#{name} (#{email})"

  isUpdating: Ember.computed.equal 'updateStatus', 'updating'

  getCustomFieldMap: (fields) ->
    customFieldMap = Ember.Map.create()


    fields.forEach (field) =>
      if contactsField = @get('customFieldValues').find((f) -> f.get('customField') == field)
        value = contactsField.get('value')

      customFieldMap.set field, Ember.Object.create(field: field, value: value)

    customFieldMap

  clearRelationships: ->
    @get('deals').compact().forEach (deal) ->
      deal.unloadRecord()

    @get('tasks').compact().forEach (task) =>
      if task.constructor isnt Radium.Meeting
        task.unloadRecord()
      else
        if task.get('reference') isnt this
          invitation = task.get('invitations').find (invitation) => invitation.get('person') == this
          invitation?.unloadRecord()
        else
          task.unloadRecord()

    @get('activities').compact().forEach (activity) ->
      activity.unloadRecord()

    Radium.Notification.all().compact().forEach (notification) =>
      if notification.get('_referenceContact') == this || notification.get('reference.sender') == this || notification.get('email.sender') == this || notification.get('_referenceEmail.sender') == this
        notification.unloadRecord()

    @_super.apply this, arguments
