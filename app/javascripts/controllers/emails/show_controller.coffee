Radium.EmailsShowController = Radium.ObjectController.extend Radium.ChangeContactStatusMixin,
  Radium.TrackContactMixin,
  actions:
    changeStatus: (email, newStatus) ->
      email.set('isPersonal', false)

      email.save().then((result) =>
        @send "flashSuccess", "email has been made public"
      ).catch (error) =>
        @resetModel()

      @_super.call(this, newStatus)

    dismissExtension: ->
      unless @get('currentUser.settings.alerts')
        alerts = Radium.Alerts.createRecord
          extensionSeen: true
        @set('currentUser.settings.alerts', alerts)
      else
        @set 'currentUser.settings.alerts.extensionSeen', true

      @get('store').commit()

  activeDeal: Ember.computed.alias('contact.deals.firstObject')
  nextTask: Ember.computed.alias('contact.nextTask')

  updateContactPoller: null

  showExtensionCTA: Ember.computed.not 'currentUser.settings.alerts.extensionSeen'

  contact: Ember.computed 'sender', ->
    sender = @get('sender')

    return sender if sender instanceof Radium.Contact

  showHud: Ember.computed 'contact', ->
    !Ember.isNone(@get('contact'))

  isUpdating: Ember.computed 'contact', 'contact.isUpdating', ->
    return false unless @get('contact')

    @get('contact.isUpdating')

  initialize: Ember.on 'init', ->
    @_super.apply this, arguments

    @set 'updateContactPoller', Radium.UpdateContactPoller.create()
