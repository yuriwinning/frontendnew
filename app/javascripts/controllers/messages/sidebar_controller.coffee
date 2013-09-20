Radium.MessagesSidebarController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  needs: ['messages']

  folders: Ember.computed.alias 'controllers.messages.folders'
  folder: Ember.computed.alias 'controllers.messages.folder'

  isSearchOpen: false
  toggleSearch: ->
    @toggleProperty 'isSearchOpen'

  contentBinding: Ember.Binding.oneWay 'controllers.messages'
  selectedContentBinding: Ember.Binding.oneWay 'controllers.messages.selectedContent'

  currentTab: 'folderTabView'
  selectTab: (tab) ->
    @set 'currentTab', "#{tab}View"

  itemController: 'messagesSidebarItem'

  showMore: ->
    @_super.apply this, arguments
    @get('content.content').trigger 'newContentAdded'
