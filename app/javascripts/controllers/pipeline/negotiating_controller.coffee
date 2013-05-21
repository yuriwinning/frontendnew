require 'mixins/controllers/bulk_action_controller_mixin'

Radium.PipelineNegotiatingController = Radium.ObjectController.extend Radium.BulkActionControllerMixin,
  needs: ['pipelineNegotiatingGroup']
  selectedGroup: Ember.computed.alias 'controllers.pipelineNegotiatingGroup.selectedGroup'

  title: 'Negotiating'

  currentDeals: ( ->
    return unless @get('negotiatingDeals.length')

    @get('negotiatingDeals').filter (deal) =>
      deal.get('status') == @get('selectedGroup')
  ).property('selectedGroup', 'negotiatingDeals.[]')

  checkedContent: ( ->
    @get('negotiatingDeals').filterProperty 'isChecked'
  ).property('currentDeals.@each.isChecked')

  hasCheckedContent: Ember.computed.bool 'checkedContent.length'

  groups: ( ->
    return [] unless @get('negotiatingGroups.length')

    Ember.ArrayProxy.create
      content: @get('negotiatingGroups')
  ).property('negotiatingGroups')
