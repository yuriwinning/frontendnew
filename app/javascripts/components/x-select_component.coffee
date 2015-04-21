Radium.XSelectComponent = Ember.Component.extend
  click: (event) ->
    event.stopPropagation()

  init: ->
    @_super.apply this, arguments
    @on "change", this, this._updateElementValue

  setup: Ember.on 'didInsertElement', ->
    this.$('input').prop('checked', !!this.get('checked'))

  _updateElementValue: ->
    Ember.run.next =>
      @set 'checked', this.$('input').prop('checked')

  checkBoxId: Ember.computed ->
    "checker-#{@get('elementId')}"
