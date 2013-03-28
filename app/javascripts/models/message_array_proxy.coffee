require 'lib/radium/aggregate_array_proxy'

Radium.MessageArrayProxy = Radium.AggregateArrayProxy.extend Ember.DeferredMixin,
  folder: 'inbox'
  currentUser: null
  isLoaded: false

  load: ->
    return if @get('isLoaded')

    @clear()

    Radium.Email.all().then (emails) =>
      @add emails
      Radium.Discussion.all().then (discussions) =>
        @add discussions
        @set 'isLoaded', true
        @resolve this

  clear: ->
    @set 'isLoaded', false
    @set 'content', []

  arrangedContent: (->
    content = @get('content')
    return unless content

    content.filter @filterFunction.bind(this)
  ).property('content.[]', 'folder')

  filterFunction: (item) ->
    @["filter#{@get('folder').classify()}"](item)

  filterInbox: (item) ->
    item.get('sender') isnt @get('currentUser')

  filterSent: (item) ->
    item.get('sender') is @get('currentUser')

  filterDiscussions: (item) ->
    item instanceof Radium.Discussion

  filterEmails: (item) ->
    item instanceof Radium.Email

  filterUntracked: (item) ->
    item.get('isTracked') is false
