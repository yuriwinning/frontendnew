require 'controllers/settings/subscriptions_mixin'

Radium.SettingsCompanyController = Radium.ObjectController.extend Radium.CurrentUserMixin,
  Radium.SubscriptionMixin,
  actions:
    resendInvite: (invite) -> 
      invitation = Radium.UserInvitationDelivery.createRecord
                    userInvitation: invite

      invitation.one 'didCreate', =>
        @send 'flashSuccess', 'invitation resent'

      invitation.one 'becameInvalid', (result) =>
        invitation.get('transaction').rollback()
        @send 'flashError', result

      invitation.one 'beameError', (result) =>
        invitation.get('transaction').rollback()
        @send 'flashError', 'An error occurred and the invitation could not be sent'

      @get('store').commit()

    cancelInvite: (invite) ->
      invite.deleteRecord()
      @store.commit()
      @send 'flashSuccess', 'The invite has been cancelled'

  needs: ['users', 'usersInvites', 'account']
  account: Ember.computed.alias 'controllers.account.model'
  companyName: Ember.computed.alias 'controllers.account.name'
  users: Ember.computed.alias 'controllers.users'
  unlimited: Ember.computed.alias 'currentUser.account.unlimited'

  pendingUsers: Ember.computed 'users.[]', 'controllers.usersInvites.[]', ->
    existing = @get('users').mapProperty('email').map (email) -> email.toLowerCase()

    @get('controllers.usersInvites').filter (invite) ->
      return if existing.contains invite.get('email').toLowerCase()
      !invite.get('confirmed') && !invite.get('isError') && !invite.get("isNew")
