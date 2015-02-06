require 'mixins/controllers/save_email_mixin'
require 'routes/mixins/send_email_mixin'

Radium.EmailsNewRoute = Ember.Route.extend  Radium.SaveEmailMixin, Radium.SendEmailMixin,
  actions:
    willTransition: (transition) ->
      if transition.targetName == "messages.index"
        controller = @controllerFor('messages')
        @controllerFor('messagesSidebar').send 'reset'

        @transitionTo 'messages.index', transition.params.messages.folder

        return false

      true

    deleteFromEditor: ->
      @controllerFor('messagesSidebar').send 'reset'
      Ember.run.next =>
        controller = @controllerFor('emailsNew')
        if controller.get('isBulkEmail')
          return @transitionTo 'people.index', 'all'

        @transitionTo 'messages', @controllerFor('messages').get('folder')

  deactivate: ->
    controller = @controllerFor('emailsNew')
    controller.get('newEmail').reset()
    @controllerFor('messagesSidebar').send 'reset'

    peopleController = @controllerFor 'peopleIndex'
    peopleController.get('checkedContent').setEach 'isChecked', false
    peopleController.set 'searchText', ''
    peopleController.set 'allChecked', false

    @controllerFor('emailsNew').set 'bulkEmail', null
