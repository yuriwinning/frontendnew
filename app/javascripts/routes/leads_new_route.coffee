Radium.LeadsNewRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'model', @get 'contactForm'
    initialStatus = @controllerFor('contactStatuses').get('content.firstObject.value')
    controller.set 'model.initialStatus', initialStatus
    initialDealState = @controllerFor('accountSettings').get('model.workflow.firstObject.name')
    controller.set 'model.initialDealState', initialDealState
    initialLeadSource = @controllerFor('account').get('leadSources.firstObject') || ''
    controller.set 'model.initialLeadSource', initialLeadSource
    controller.get('model').reset()
    controller.set 'model.user', @controllerFor('currentUser').get('model')

  contactForm:  Radium.computed.newForm('contact')

  # FIXME: Should we not just use reset?
  contactFormDefaults: Ember.computed ->
    isNew: true
    isSubmitted: false
    isSaving: false
