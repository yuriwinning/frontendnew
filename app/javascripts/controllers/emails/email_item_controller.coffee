Radium.EmailsItemController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  Radium.SaveEmailMixin,
  Radium.SaveTemplateMixin,
  Radium.TrackContactMixin,
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'
      return

    deleteFromEditor: ->
      @set('showReplyForm', false)

      false

    showCommentBox: ->
      @toggleProperty 'showCommentBox'
      false

    showForm: (form) ->
      @setProperties
        showFormBox: true
        currentForm: form

      @set 'formBox.activeForm', form
      return

    toggleMeta: ->
      @toggleProperty 'showMeta'
      return

    toggleReplyForm: ->
      @toggleProperty 'showReplyForm'
      return

    archiveEmail: (item) ->
      @removeSidebarItem(item, 'archive')

    deleteEmail: (item) ->
      @removeSidebarItem(item, 'delete')

    cancelCheckForResponse: (email) ->
      email.set 'checkForResponse', null

      email.save().then (result) =>
        @send 'flashSuccess', 'Response check cancelled'

      false

    closeForms: ->
      @set('showReplyForm', false)

    hideForm: ->
      @set 'showFormBox', false
      @set 'formBox.activeForm', null

  removeSidebarItem: (item, action) ->
    if @get('showReplyForm')
      @send 'closeForms'
      return

    parentController = @get('parentController')

    @send action, item

  showMeta : false
  currentForm: 'todo'

  isTracked: Ember.computed 'sender', 'sender.isPublic', ->
    sender = @get('sender')

    return false unless sender instanceof Radium.Contact

    sender.get('isPublic')

  notTracked: Ember.computed 'sender', 'sender.isPublic', ->
    sender = @get('sender')

    return false unless sender instanceof Radium.Contact

    not sender.get('isPublic')

  senderIsCurrentUser: Ember.computed 'sender', 'currentUser', ->
    @get('currentUser') == @get('sender')

  notFromUser: Ember.computed.not 'senderIsCurrentUser'

  formBox: Ember.computed 'todoform', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      meetingForm: @get('meetingForm')

  todoForm: Radium.computed.newForm('todo')

  email: Ember.computed 'model', ->
    model = @get('model')
    if model instanceof Radium.ObjectController
      model.get('model')
    else
      model

  todoFormDefaults: Ember.computed 'email', 'tomorrow', ->
    reference: @get('email')
    finishBy: null
    user: @get('currentUser')
    description: "Follow up with #{@get('model.subject')} email tomorrow."

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', 'now', ->
    isExpanded: true
    topic: null
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()

  replyEmail: Ember.computed 'model', ->
    replyForm = Radium.ReplyForm.create
      currentUser: @get('currentUser')

    replyForm.set('repliedTo', @get('email'))

    replyForm

  needs: ['contacts', 'users', 'userSettings', 'peopleIndex', 'messages', 'messagesSidebar']

  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'

  deals: Ember.computed.oneWay 'controllers.deals'

  hideUploader: true
  hasComments: Ember.computed.bool 'comments.length'
  renderComments: Ember.computed.or 'hasComments', 'showCommentBox'

  canArchive: Ember.computed 'controllers.messages.folder', ->
    @get('controllers.messages.folder') != 'archive'

  _initialize: Ember.on 'init', ->
    @set('showReplyForm', false)
