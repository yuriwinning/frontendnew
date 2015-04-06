require 'components/autocomplete_mixin'
require 'mixins/auto_fill_hack'
require 'mixins/validation_mixin'
require 'mixins/save_model_key_down'

Radium.AutocompleteTextboxComponent = Ember.Component.extend Radium.AutocompleteMixin,
  Radium.AutoFillHackMixin,
  Radium.ValidationMixin,
  Radium.KeyConstantsMixin,
  Radium.SaveModelKeyDownMixn,

  actions:
    setBindingValue: (object) ->
      value = if typeof object == "string"
                object
              else
                object.get('person') || object

        if @writeableValue && @hasOwnProperty 'queryKey'
          @set('value', value.get(@queryKey))
        else
          @set 'value', value

      @getTypeahead().hide()

      return unless @get('action')

      Ember.run.next =>
        @sendAction 'action', value

      false

    showAll: ->
      return if @get('isAsync')
      return if @get('disabled')

      $('.typeahead.dropdown-menu').hide()

      typeahead = @getTypeahead()

      return typeahead.hide() if typeahead.shown

      source = @source.toArray()

      typeahead.render(source.slice(0, source.length)).show()

      false

    removeValue: ->
      @set('value', null)
      @autocompleteElement().val('').focus()
      @send 'showAll'
      @getTypeahead().hide()
      event.stopPropagation()
      event.preventDefault()
      false

  sync: Ember.computed.not 'isAsync'

  classNameBindings: [':autocomplete-textbox', ':field', ':combobox', ':control-box', 'isInvalid', 'isAsync', 'sync']

  autocompleteElement: ->
    @$('input[type=text].combobox:first')

  input: (e) ->
    @_super.apply this, arguments

    el = @autocompleteElement()

    text = el.val()

    @query = text

    if @writeableValue
      @set 'value', text

  valueDidChange: Ember.observer 'value', ->
    @setValueText()

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @setValueText()

    @autocompleteElement().off 'blur'
    typeahead = @getTypeahead()

    $('body').on 'click.autocomplete.txt.component', (e) =>
      if typeahead = @getTypeahead()
        typeahead.hide() if typeahead.shown

  autocompleteOver: Ember.on 'willDestroyElement', ->
    $('body').off 'click.autocomplete.txt.component'

  setValueText: ->
    el = @autocompleteElement()

    unless value = @get('value')
      return el.val('')

    complete = =>
      displayValue = if typeof value == 'string'
                       value
                     else
                       value.get(@queryKey)

      el.val(displayValue) if displayValue

    if value instanceof DS.Model && !value.get('isLoaded')
      observer = ->
        return unless value.get('isLoaded')

        complete()

        value.removeObserver 'isLoaded', observer

      value.addObserver 'isLoaded', observer
    else
      complete()

  focusIn: (e) ->
    Em.run.next =>
      return if @get('isAsync')

      el = @autocompleteElement()

      return unless el

      return @autocompleteElement().select() if el.val()

      return if @get('value')

      return unless e.target == el.get(0)

      if !el.val().length && !@getTypeahead().shown
        @send 'showAll'

      e.stopPropagation()
      e.preventDefault()

    return false
