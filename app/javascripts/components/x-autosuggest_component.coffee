require 'components/key_constants_mixin'

Radium.XAutosuggestComponent = Ember.Component.extend
  actions:
    addSelection: (item) ->
      @get('destination').addObject item

    removeSelection: (item) ->
      @get('destination').removeObject item

  classNameBindings: [
    'isInvalid'
    'hasUsers:is-valid'
    ':autocomplete'
  ]

  showAvatar: true
  showAvatarInResults: true
  minChars: 1
  deleteOnBackSpace: true

  abortResize: false

  resizeInputBox: ->
    input = @$('li.as-original input')

    return unless input

    if @get('abortResize')
      return input.width(50)

    totalWidth = @$('.as-selections').outerWidth(true)

    last = @$('.as-selections li.as-selection-item:last')

    if last.length
      left = last.position().left + last.outerWidth(true)
    else
      left = @$('.as-selections').position().left

    inputWidth = totalWidth - left

    inputWidth = totalWidth if inputWidth < 100

    input.width inputWidth

  didInsertElement: ->
    @_super.apply this, arguments
    @$('input[type=text]').addClass('field')
    @resizeInputBox()

  destinationDidChange: Ember.observer 'destination.[]', ->
    Ember.run.scheduleOnce 'afterRender', this, "resizeInputBox"

  filterResults: (item) ->
    !@get('destination').contains(item)

  retrieve: (query, callback) ->
    source = @get('source')

    return unless source.get('length')

    results = source.filter(@get('parentView').filterResults.bind(this))
                   .map (item) =>
                      @mapSearchResult.call this, item

    callback(results, query)

  selectionAdded: (item) ->
    if typeof item == "string"
      item = Ember.Object.create
                email: item

    @send('addSelection', item)

  newItemCriteria: (text) ->
    Radium.EMAIL_REGEX.test text

  allowSpaces: false

  autocomplete: Ember.TextField.extend Radium.KeyConstantsMixin,
    classNameBindings: [':field']
    currentUser: Ember.computed.alias 'targetObject.currentUser'
    destinationBinding: 'parentView.destination'
    placeholderBinding: 'parentView.placeholder'
    sourceBinding: 'parentView.source'
    tabindexBinding: 'parentView.tabindex'
    deleteOnBackSpace: Ember.computed.oneWay 'parentView.deleteOnBackSpace'

    keyDown: (e) ->
      args = Array.prototype.slice.call(arguments)

      callSuper = =>
        @_super.apply this, args

      unless [@DELETE, @ENTER, @SPACE].contains e.keyCode
        return callSuper()

      value = @get('value') || ''

      if e.keyCode == @SPACE && @get('parentView.allowSpaces')
        return callSuper()

      if [@SPACE, @ENTER].contains e.keyCode
        unless @get('parentView').newItemCriteria(value)
          return callSuper()

        @get('parentView').selectionAdded value
        @set 'value', ''
        return false

      return callSuper() if value.length

      return unless @get('deleteOnBackSpace')

      last = @get('destination.lastObject')

      return unless last

      @get('parentView').send('removeSelection', last)

      false

    didInsertElement: ->
      @_super.apply this, arguments
      Ember.run.scheduleOnce 'afterRender', this, 'addAutocomplete'

    addAutocomplete: ->
      options =
        asHtmlID: @get('elementId')
        selectedItemProp: "name"
        searchObjProps: "name"
        formatList: @formatList.bind(this)
        getAvatar: @getAvatar.bind(this)
        selectionAdded: @get('parentView').selectionAdded.bind(@get('parentView'))
        resultsHighlight: true
        canGenerateNewSelections: true
        usePlaceholder: true
        retrieveLimit: 8
        startText: @get('placeholder')
        keyDelay: 100
        minChars: @get('parentView').get('minChars')

      if @get('parentView').newItemCriteria
        options = $.extend {}, options, newItemCriteria: @get('parentView').newItemCriteria.bind(this)

      @$().autoSuggest {retrieve: @get('parentView').retrieve.bind(this)}, options

    formatList: (data, elem) ->
      content = ""

      if @get('parentView.showAvatarInResults')
        content = """
          #{@getAvatar(data)}
          #{data.name}
        """
      else
        content = """
          #{data.name}
        """

      elem.html(content)

    mapSearchResult: (result) ->
      currentUser = @get('currentUser')

      email= result.get('email')
      name = result.get('name')

      name = if name && email
                "#{name} (#{email})"
             else if name
                name
             else
               email

      name = if !result.get('isExternal') && result.get('person')?.constructor == Radium.User && result.get('id') == currentUser.get('id')
                "#{name} (Me)"
             else
               name

      avatarUrl = if result.get('avatarKey')
                    "http://res.cloudinary.com/radium/image/upload/c_fit,h_32,w_32/#{result.get('avatarKey')}.jpg"
                  else
                    "/images/default_avatars/small.png"

      result =
        value: "#{result.constructor}-#{result.get('id')}"
        name: name
        avatar: avatarUrl
        data: result

    getAvatar: (data) ->
      """
        <img src="#{data.avatar}" title="#{data.name}" class="avatar avatar-small">
      """
