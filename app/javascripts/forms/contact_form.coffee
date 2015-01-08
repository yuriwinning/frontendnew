require 'forms/form'

Radium.ContactForm = Radium.Form.extend
  data: ( ->
    name: @get('name')
    companyName: @get('companyName')
    user: @get('user')
    about: @get('about')
    source: @get('source')
    contactStatus: @get('contactStatus')
    dealState: @get('dealState')
    phoneNumbers: Ember.A()
    emailAddresses: Ember.A()
    addresses: Ember.A()
    tagNames: Ember.A()
  ).property().volatile()

  isValid: Ember.computed 'name', 'companyName', 'user', 'source', ->
    return if Ember.isEmpty(@get('name')) && Ember.isEmpty(@get('companyName'))
    return if Ember.isEmpty(@get('source'))
    return unless @get('user')
    true

  create:  ->
    data = @get('data')
    if status = data.contactStatus
      delete data.contactStatus
      data.contactStatus = Radium.ContactStatus.all().find (s) -> s.get('id') == status

    p data.contactStatus

    contact = Radium.CreateContact.createRecord data

    contact.set 'name', 'unknown contact' if Ember.isEmpty(contact.get('name'))

    contact.set('companyName', null) if Ember.isEmpty(contact.get('companyName'))

    @get('phoneNumbers').forEach (phoneNumber) ->
      number = phoneNumber.get('value')
      if number.length && number != "+1"
        contact.get('phoneNumbers').push
          name: phoneNumber.get('name')
          number: phoneNumber.get('value')
          primary: phoneNumber.get('isPrimary')

    @get('emailAddresses').forEach (email) ->
      if email.get('value.length')
        contact.get('emailAddresses').push
          name: email.get('name')
          address: email.get('value')
          primary: email.get('isPrimary')

    @get('addresses').forEach (address) =>
      if @addressHasValue(address)
        contact.get('addresses').push address.getProperties('name', 'primary', 'street', 'state', 'city', 'country', 'zipcode')

    @get('tagNames').forEach (tag) ->
      contact.get('tagNames').push tag.get('name')

    contact

  addressHasValue: (address) ->
    return true if address.get('street.length') > 1
    return true if address.get('state.length') > 1
    return true if address.get('city.length') > 1
    return true if address.get('zipcode.length') > 1

  reset: ->
    @_super.apply this, arguments
    @set 'isNew', true
    @set 'name', ''
    @set 'about', ''
    @set 'source', @get('initialLeadSource')
    @set 'companyName', null
    @set 'company', ''
    @set 'dealState', @get('initialDealState')
    @set 'tagNames', Ember.A()
    @set 'emailAddresses', Ember.A([Ember.Object.create(name: 'work', value: '', isPrimary: true)])
    @set 'phoneNumbers', Ember.A([Ember.Object.create(name: 'work', value: '', isPrimary: true)])
    @set 'addresses', Ember.A([Ember.Object.create(name: 'work', isPrimary: true, street: '', city: '', state: '', zipcode: '', country: '')])
