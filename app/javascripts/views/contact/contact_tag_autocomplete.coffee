require 'lib/radium/tag_autocomplete'

Radium.ContactTagAutocomplete = Radium.TagAutoComplete.extend
  actions:
    removeSelection: (tag) ->
      @get('source').removeObject tag
      false

  init: ->
    @_super.apply this, arguments
    Ember.addBeforeObserver this, 'controller.company.tagNames', null, 'sourceWillChange'

  sourceWillChange: ->
    return unless @get('controller.isNew')
    return unless @get('controller.company.tagNames.length')

    @get('source').removeObjects @get('source').filter (tag) =>
      @get('source').mapProperty('name').contains (tag.get('name'))

  companyDidChange: Ember.observer 'controller.company', ->
    return unless @get('controller.isNew')

    return unless @get('controller.company.tagNames.length')

    companyTags = @get('controller.company.tagNames').toArray().reject (tag) =>
      @get('source').mapProperty('name').contains (tag.get('name'))

    @get('source').addObjects(companyTags)
