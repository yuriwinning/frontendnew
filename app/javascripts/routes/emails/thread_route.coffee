require 'routes/emails/base_show_route'

Radium.EmailsThreadRoute = Radium.ShowRouteBase.extend
  afterModel: (model, transition) ->
    controller = @controllerFor('emailsThread')
    controller.set 'isLoading', true
    controller.set 'allLoaded', false
    controller.set 'page', 1
    controller.set 'hasReplies', true

    pageSize = controller.get('pageSize')
    query =
            name: 'reply_thread'
            emailId: model.get('id')
            page: 1
            page_size: pageSize

    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.Email.find(query).then((replies) ->
        model.set 'replies', replies
        resolve model
      ).catch ->
        controller.set 'false', true
        controller.set 'replies', []
        resolve(model)

  setupController: (controller, model) ->
    unless model.get('isRead')
      model.set('isRead', true)
      @store.commit()

    @controllerFor('messages').set 'selectedContent', model

    controller.set('currentPage', 1)

    controller.set 'isLoading', true

    controller.set 'model', Ember.A([model])

    replies = model.get('replies')

    unless replies.get('length')
      controller.set 'isLoading', false
      controller.set 'allLoaded', true
      controller.set 'hasReplies', false
      return

    replies.forEach (reply) ->
      observer = ->
        return unless reply.get('isLoaded')

        reply.removeObserver 'isLoaded', observer
        controller.get('model').pushObject(reply)

        if controller.get('model.length') >= replies.get('length') || controller.get('model.length') == controller.get('pageSize')
          controller.set 'isLoading', false

          controller.set('allLoaded', controller.get('model.length') < controller.get('pageSize'))

      if reply.get('isLoaded')
        observer()
      else
        reply.addObserver 'isLoaded', observer
