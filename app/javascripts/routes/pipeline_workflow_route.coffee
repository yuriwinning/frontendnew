Radium.PipelineWorkflowRoute = Radium.PipelineBaseRoute.extend Radium.BulkActionEmailEventsMixin,
  Radium.ClearCheckedMixin,
  model: (params) ->
    params.pipeline_state

  setupController: (controller, state) ->
    @_super.apply this, arguments
    pipeline = @modelFor('pipeline')

    unless pipeline.get state
      Ember.defineProperty pipeline, state, Ember.computed( ->
        Radium.Deal.filter (deal) ->
          deal.get('status') == state
      ).property("#{state}.[]")

    controller = @controllerFor('pipelineWorkflowDeals')
    controller.set('title', state)
    controller.set('model', pipeline.get(state))
    controller.set 'showHeader', true
    @clearChecked()

  renderTemplate: ->
    @render 'pipeline/workflow_deals',
      into: 'pipeline'

  deactivate: ->
    @clearChecked()
