require 'controllers/sidebar/sidebar_base_controller'

Radium.EmailAddressesForm = Radium.Form.extend
  init: ->
    @set 'content', Ember.Object.create()
    @_super.apply this, arguments
    @reset()

  reset: ->
    @_super.apply this, arguments
    @set 'emailAddresses', Ember.A()

Radium.SidebarEmailAddressesController = Radium.SidebarBaseController.extend
  isValid: true

  commit: ->
    @get('form.emailAddresses').forEach (email) =>
      if email.hasOwnProperty 'record'
        email.record.setProperties(name: email.get('name'), value: email.get('value'), isPrimary: email.get('isPrimary'))
      else
        @get('content.emailAddresses').createRecord email.getProperties('name', 'value', 'isPrimary')

    @get('content.transaction').commit()

  setForm: ->
    emailAddresses = @get('emailAddresses')
    formEmailAddress = @get('form.emailAddresses')

    unless emailAddresses.get('length')
      formEmailAddress.pushObject Ember.Object.create
        isPrimary: true, name: 'Work', value:''

      return

    emailAddresses.forEach (email) =>
      formEmailAddress.pushObject Ember.Object.create(
        isPrimary: email.get('isPrimary'), name: email.get('name'), value: email.get('value'), record: email
      )

  form: ( ->
    Radium.EmailAddressesForm.create()
  ).property()
