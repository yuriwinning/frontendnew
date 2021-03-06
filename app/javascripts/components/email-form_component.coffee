require 'mixins/editor_mixin'

Radium.EmailFormComponent = Ember.Component.extend Radium.EditorMixin,
  actions:
    saveTemplate: (form) ->
      @sendAction "saveTemplate", form

      false

    submit: (form) ->
      @set 'form.isDraft', false

      @sendAction 'saveEmail', form

      false

    toggleOptions: ->
      @toggleProperty 'showOptions'
      false

    submitFromPeople: (form) ->
      controller = @container.lookup('controller:peopleIndex')

      bulkParams = controller.get('content.params')

      bulkParams.returnParameters = user: bulkParams.user, list: bulkParams.list

      findRecord = (type, id) ->
        type.all().find (r) -> r.get('id') == id

      unless controller.get('allChecked')
        bulkParams.ids = controller.get('checkedContent').mapProperty('id')
        delete bulkParams.list
        delete bulkParams.user
        bulkParams.filter = null
      else
        bulkParams.ids = []
        bulkParams.filter = controller.get('filter')

        if controller.get('isQuery')
          bulkParams.customquery = controller.get('customquery')

        if controller.get('list') && controller.get('isListged')
          bulkParams.list = findRecord(Radium.List, bulkParams.list)
        else if controller.get('isAssignedTo') && user_id = controller.get('user')
          bulkParams.user = findRecord(Radium.User, bulkParams.user)

      searchText = $.trim(controller.get('searchText') || '')

      if searchText.length
        bulkParams.like = searchText

      @sendAction('confirmBulkEmail', form, bulkParams)

      false

    createBulkEmail: (form) ->
      if @get('checkForResponseSet') && !@get('checkForResponse')
        return @flashMessenger.error 'you need to set a check for response time if you want to check for a responese'
      to = form.get('to')

      contactIds = to.filter((item) -> item.get('_personContact')).mapProperty('_personContact.id')

      listIds = to.filter((item) -> item.get('resourceList')).mapProperty('resourceList.id')

      Ember.assert 'You need a valid selection', contactIds.length || listIds.elgnth

      bulkParams =
        filter: null
        ids: contactIds || []
        lists: listIds || []
        private: false
        public: true
        checkForResponse: @get('checkForResponse')
        returnParameters:
          list: undefined
          user: undefined

      @sendAction 'createBulkEmail', form, bulkParams

      false

    saveAsDraft: (form, transitionFolder) ->
      @set 'form.isDraft', true
      @sendAction 'saveEmail', form, transitionFolder: transitionFolder

      false

    scheduleDelivery: (form, date) ->
      if typeof date is "string"
        if date == 'tomorrow'
          date = Ember.DateTime.create().advance(day: 1)

      if @get('bulkMode')
        form.set 'sendTime', date

        if @get('fromPeople')
          return @send('submitFromPeople', form)

        return @send('createBulkEmail', form)

      @set 'form.sendTime', date
      @send 'saveAsDraft', form, 'scheduled'
      #Hack to close menu
      $(document).trigger('click.date-send-menu')

    showSendLater: ->
      @$('.send-later').css(display: 'inline-block')
      false

    setCheckForResponse: (date) ->
      @set 'form.checkForResponse', date
      @set('checkForResponseSet', true)
      @$('.check-response-opener').removeClass 'open'
      $(document).trigger('click.date-send-menu')
      false

    cancelCheckForResponse: ->
      form = @get('form')

      return unless form.get('checkForResponse')

      form.set 'checkForResponse', null

      Ember.run.next =>
        @set('checkForResponseSet', false)

      @sendAction('saveEmail', form)

      false

    cancelDelivery: (form) ->
      form.set 'sendTime', null

      @send 'saveAsDraft', form, 'drafts'

      false

    removeFromBulkList: (recipient) ->
      @get('form.to').removeObject recipient

      # FIXME: hack to stop the recipients list disappearing
      Ember.run.next =>
        @$('.bulk-recipients-component').css 'max-height': '107px'

      false

    closeModal: ->
      @$().one $.support.transition.end, =>
        @set 'showSignatureModal', false

      @$('.modal').removeClass('in')

    addSignature: ->
      if signature = @get('signature')
        @send 'appendSignature'
      else
        @set 'showSignatureModal', true
        Ember.run.next =>
          @$('.modal').addClass 'in'
          @$('.modal textarea').focus()

    createSignature: ->
      @set 'signatureSubmited', true

      return unless @get('signature.length')

      @set 'signatureSubmited', false

      @sendAction 'addSignature', @get('signature')

      @send 'appendSignature'
      @send 'closeModal'

    appendSignature: ->
      editable = @$('.note-editable')
      current = editable.html()
      currentLength = editable.text().length
      signature = @get('signature').replace(/\n/g, '<br/>')

      newMessage = "#{current}<br/><br/>#{signature}"

      @set 'form.html', newMessage
      editable.html(newMessage)
      @set 'form.html', newMessage
      editable.height("+=50")

      # FIXME: editor menu appears sometims
      @$('ul.typeahead').hide()

      # FIXME: restore cursor to position
      # before signature added
      # editable.restoreCursor(currentLength)

      @EventBus.publish('removePlaceHolder')

      @$('.prompt').hide()
      false

    expandList: (section) ->
      @set("show#{section.capitalize()}", true)

    hideAddSignature: ->
      @set 'signatureAdded', true

    changeViewMode: (mode) ->
      @sendAction "changeViewMode", mode

      false

    deleteFromEditor: ->
      if @get('forwardOrReply')
        @get('form').reset()
        @set 'mode', 'single'

      @sendAction "deleteFromEditor"

      false

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    @$('.info').tooltip(html: true)

    @EventBus.subscribe('email:reset', this, 'onFormReset')

    Ember.run.scheduleOnce 'afterRender', this, '_afterSetup'

    @$('.drop').on 'click', (e) =>
      @$('.check-response-opener').toggleClass('open')
      e.preventDefault()
      e.stopPropagation()


    $(document).on 'click.date-send-menu', (e) =>
      return unless e.target.hasOwnProperty('tagName')

      return true if e.target?.type == 'file'
      return true if e.target.tagName == 'A' || e.target.parentNode.tagName == 'A'

      target = $(e.target)

      return if target.hasClass('ui-timepicker-selected') || target.parents('.date-picker-component').length

      return if target.parents('.date-timepicker-component').length

      @$('.send-later').hide()
      @$('.check-response-opener').removeClass('open')

      e.preventDefault()
      e.stopPropagation()
      false

  onFormReset: ->
    if @get('signature')
      Ember.run.next =>
        Ember.run.next =>
          @send "appendSignature"

  _afterSetup: ->
    @$('.autocomplete.email input[type=text]').focus()

    if @get('signature')
      Ember.run.next =>
        @send "appendSignature"

    return unless @get('fromPeople')

    toLength = @get('form.to.length')
    totalRecords = @get('form.totalRecords')

    return if toLength >= totalRecords

    remaining = totalRecords - toLength

    info = """
      <div class="bulk-recipient-component item">
        <div class="name">
          <b>Showing </b>
          <span class="count">#{toLength}</span>
          <span class="to-length">of</span>
          <span class="count">#{totalRecords}</span> selected contacts
        </div>
      </div>
    """

    @$('.bulk-recipients-component.recipients').append($(info))

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments
    @EventBus.unsubscribe('email:reset')

    el = @$('.info')

    if el.data('tooltip')
      el.tooltip('destroy')

    @$('.drop').off 'click'
    $(document).off 'click.date-send-menu'

  signatureAdded: false
  showSignatureModal: false

  checkForResponse: Ember.computed.oneWay 'form.checkForResponse'
  checkForResponseFormatted: Ember.computed.oneWay 'form.checkForResponseFormatted'
  checkForResponseSet: false

  isScheduled: Ember.computed.oneWay 'form.isScheduled'
  sendTimeFormatted: Ember.computed.oneWay 'form.sendTimeFormatted'

  isSubmitted: Ember.computed.oneWay 'form.isSubmitted'

  isDraft: Ember.computed.oneWay 'form.isDraft'

  showNavigation: Ember.computed 'isDraft', 'forwardMode', 'replyMode', 'formMode', ->
    return if @get('isDraft') || @get('forwardMode') || @get('replyMode') || @get('formMode')

    true

  forwardOrReply: Ember.computed 'forwardMode', 'replyMode', ->
    @get('forwardMode') || @get('replyMode')

  showOptions: Ember.computed 'singleMode', 'bulkMode', 'replyMode', 'forwardMode', 'formMode', ->
    !@get('bulkMode')

  showSubject: Ember.computed 'showOptions', 'replyMode', ->
    return true unless @get('replyMode')

    @get('showOptions')

  toIsInvalid: Ember.computed 'isSubmitted', 'form.to.[]', 'form.to.@each.email', ->
    return unless @get('isSubmitted')

    !!!@get('form.to.length')

  toIsValid: Ember.computed 'form.to.[]', ->
    @get('form.to.length') > 0

  bulkQueryParameters: (query) ->
    scopes: ['user', 'contact', 'list']
    term: query
    email_only: true

  signatureTextArea: Radium.TextArea.extend
    classNameBindings: ['isInvalid']
    placeholder: 'Signature'
    isInvalid: Ember.computed 'value', 'targetObject.signatureSubmited', ->
      return unless @get('targetObject.signatureSubmited')

      @get('value').length == 0

    focusOut: ->
      return unless value = @get('value')

      @send "createSignature"

  singleMode: Ember.computed.equal 'mode', 'single'
  bulkMode: Ember.computed.equal 'mode', 'bulk'
  replyMode: Ember.computed.equal 'mode', 'reply'
  forwardMode: Ember.computed.equal 'mode', 'forward'
  formMode: Ember.computed.equal 'mode', 'form'

  messageIsInvalid: Ember.computed 'isSubmitted', 'form.html.length', ->
    return false unless @get('isSubmitted')

    message = @get('form.html') || ''

    !!!message.length

  submitAction: Ember.computed 'singleMode', 'bulkMode', 'fromPeople', ->
    if @get('singleMode') || @get('forwardOrReply') || @get('formMode')
      "submit"
    else if @get('bulkMode') && @get('fromPeople')
      "submitFromPeople"
    else
      "createBulkEmail"

  templateQueryParameters: (query) ->
    like: query

  responseNotSet: Ember.computed 'checkForResponseSet', 'checkForResponse', ->
    return false unless @get('checkForResponseSet')

    !!!@get('checkForResponse')
