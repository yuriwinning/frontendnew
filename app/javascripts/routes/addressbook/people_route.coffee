Radium.PeopleIndexRoute = Radium.Route.extend
  queryParams:
    user:
      refreshModel: true
    tag:
      refreshModel: true

  beforeModel: (transition) ->
    filter = transition.params['people.index'].filter

    controller = @controllerFor 'people.index'

    controller.send 'updateTotals'
    controller.set 'filter', filter

  model: (params) ->
    controller = @controllerFor 'peopleIndex'

    controller.set('user', params.user) if params.user

    controller.set('tag', params.tag) if params.tag

    controller.set 'filter', params.filter

    filterParams = controller.get('filterParams')

    Radium.InfiniteDataset.create
      type: Radium.Contact
      params: filterParams