Radium.EmailItemView = Em.View.extend Radium.ContentIdentificationMixin,
  templateName: 'radium/inbox/email_item'
  classNames: 'email'.w()
  showActions: false

  showActionSection: ->
    @toggleProperty('showActions')

    @get('actionContainer').set('currentView', null) unless @get('showActions')

  ActionContainer: Em.ContainerView.extend()

  toggleTodoForm: (e) ->
    @showTodoForm('email', 'todo created')

  toggleFollowCall: (e) ->
    @showTodoForm('call', 'follow up call created')

  toggleMeetingForm: (e) ->
    formContainer = @get('actionContainer')

    if formContainer.get('currentView')
      formContainer.set('currentView', null)

    form = Radium.MeetingFormView.create
      close: ->
        unless $(event.target).hasClass('close-form')
          @get('parentView.parentView').displayConfirmation('meeting created')
        else
          @get('parentView').set('currentView', null)

    form.set 'controller', Radium.MeetingFormController.create()

    formContainer.set 'currentView', form

  showTodoForm: (kind, notification) ->
    formContainer = @get('actionContainer')

    if formContainer.get('currentView')
      formContainer.set('currentView', null)

    todoFormView = Radium.TodoFormView.create(Radium.Slider,
      selectionBinding: 'parentView.parentView.content',
      kind: kind
      createTodo: Radium.get('router.inboxController').createTodo
      displayNotification: ->
        @get('parentView.parentView').displayConfirmation(notification)
      )

    formContainer.set 'currentView', todoFormView

  displayConfirmation: (text) ->
    ele = $('.email-alert-area', @get('parentView.parentView').$())
    Radium.Utils.notify text, ele: ele

  FormContainer: Em.ContainerView.extend
    init: ->
      @_super.apply this, arguments

      commentsView = Radium.InlineCommentsView.create
        autoresize: false
        controller: Radium.InlineCommentsController.create
          context: this
          commentParentBinding: 'context.parentView.content'

      @get('childViews').pushObject commentsView
