require 'forms/form'

Radium.EmailForm = Radium.Form.extend
  includeReminder: false
  reminderTime: 5

  init: ->
    @set 'content', Ember.Object.create()
    @_super()

  reset: ->
    @_super.apply this, arguments
    @set('subject', '')
    @set('message', '')
    @get('to').clear()
    @get('cc').clear()
    @get('bcc').clear()

  data: ( ->
    subject: @get('subject')
    message: @get('message')
    sentAt: Ember.DateTime.create()
    to: @get('to').map (person) =>
      person.get('email')

    cc: @get('cc').map (person) =>
      person.get('email')

    bcc: @get('bcc').map (person) =>
      person.get('email')
  ).property().volatile()

  isValid: ( ->
    @get('to.length') && @get('message.length')
  ).property('to.[]', 'message')
