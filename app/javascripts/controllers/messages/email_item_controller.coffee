Radium.EmailItemController = Radium.ObjectController.extend
  showActions: false
  showReply: false
  showMeta : false

  toggleFormBox: ->
    @toggleProperty 'showFormBox'

  showReplySection: ->
    @toggleProperty 'showReply'

  formBox: (->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      callForm: @get('callForm')
  ).property('todoForm', 'callForm')

  todoForm: Radium.computed.newForm('todo')

  todoFormDefaults: (->
    reference: @get('model')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  callForm: Radium.computed.newForm('call', canChangeContact: false)

  callFormDefaults: (->
    finishBy: @get('tomorrow')
    user: @get('currentUser')
  ).property('model', 'tomorrow')

  toggleMeta: -> @toggleProperty 'showMeta'

