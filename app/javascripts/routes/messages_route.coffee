require 'routes/drawer_support_mixin'

Radium.MessagesRoute = Ember.Route.extend Radium.DrawerSupportMixin,
  events:
    selectFolder: (name) ->
      @controllerFor('messages').set 'selectedContent', null
      @controllerFor('messages').set 'folder', name
      @closeDrawer()

    toggleFolders: ->
      @toggleDrawer 'messages/folders'

    selectContent: (item) ->
      @controllerFor('messages').set 'selectedContent', item

    createEmail: ->
      @controllerFor('messages').toggleProperty 'createEmail'

  model: ->
    Radium.Message.create folder: 'inbox'

  renderTemplate: ->
    # FIXME this seems wrong. It uses drawer_panel for
    # some reason. This seems like an Ember bug
    @render into: 'application'

    @render 'messages/sidebar',
      into: 'messages'
      outlet: 'sidebar'

    @render 'messages/drawer_buttons'
      into: 'drawer_panel'
      outlet: 'buttons'
