Fixture = Ember.Object.extend
  type: null
  name: null

window.FixtureSet = FixtureManager = Ember.Object.extend
  init: ->
    @set('fixtures', Em.Map.create())

    @_super()

    for type, fixtures of FixtureSet.fixtures
      @add(type, fixtures)

  store: ( ->
    if store = @get('_store')
      store
    else
      Radium.store
  ).property('_store')

  add: (type, fixtures) ->
    type = Ember.get(Ember.lookup, type) if typeof(type) == 'string'

    for name, data of fixtures
      fixture = Fixture.create
        type: type
        name: name
        data: data

      @addFixture(type, fixture)

  # TODO: extract this as some kind of hook
  afterAdd: (type, fixtureSet, fixture) ->
    if type == Radium.FeedSection
      # automatically add next_date and previous_date
      fixtures = []
      fixtureSet.forEach (name, f) -> fixtures.pushObject(f)

      fixtures = fixtures.sort (a, b) ->
        if a.get('data').id > b.get('data').id then 1 else -1

      fixtures.forEach (fixture, i) ->
        if previous = fixtures.objectAt(i - 1)
          previous.get('data').next_date = fixture.get('data').id
          fixture.get('data').previous_date = previous.get('data').id
        if next = fixtures.objectAt(i + 1)
          next.get('data').previous_date = fixture.get('data').id
          fixture.get('data').next_date = next.get('data').id


  addFixture: (type, fixture) ->
    fixtures = @fixturesForType(type)
    fixtures.set(fixture.get('name'), fixture)
    @afterAdd(type, fixtures, fixture)

  fetch: (type, name) ->
    @fixturesForType(type).get(name)

  fixturesForType: (type) ->
    store = @get('store')
    map = @get('fixtures')

    fixtures = map.get(type)
    unless fixtures
      fixtures = Ember.Map.create()
      map.set(type, fixtures)
      self = this
      this[Radium.Core.typeToString(type).pluralize()] = (name) ->
        fixture = fixtures.get(name)
        data    = fixture.get('data')
        store.load(type, data.id, data) unless store.isInStore(type, data.id)
        store.find(type, data.id)

    fixtures

  loadAll: (options = {}) ->
    now = options.now
    store = @get('store')

    @get('fixtures').forEach (type, fixtures) ->
      type.FIXTURES ?= []
      fixtures.forEach (name, fixture) ->
        data = fixture.get('data')
        type.FIXTURES.pushObject(data)
        if now
          store.load(type, data.id, data)

    this

FixtureSet.reopenClass
  add: (type, fixture) ->
    FixtureSet.fixtures ?= {}
    FixtureSet.fixtures[type] ?= {}
    $.extend FixtureSet.fixtures[type], fixture

  addFixtureSet: (fixtureSet, loadDependencies = false) ->
    for own key, value of fixtureSet
      type = Radium.Core.typeFromString(value.def.name)
      # delete value.def
      fixture = {}
      fixture[key] = value
      FixtureSet.add type, fixture

      continue unless loadDependencies

      for own k, v of value
        continue unless $.isArray(v) and v.length > 0
        continue unless $.isArray(v[0]) and Em.typeOf(v[0][0]) is "class"
        for klass in v
          factoryType = klass[0].toString().split('.').pop().pluralize().toLowerCase()
          continue if klass[0].FIXTURES
          FixtureSet.addFixtureSet(Factory[factoryType]) if Factory[factoryType]

  load: ->
    for definition in Factory.getDefinitions()
      FixtureSet.addFixtureSet definition

  loadFixtures: (types, store) ->
    types = [types] unless $.isArray types

    for type in types
      FixtureSet.addFixtureSet Factory[type.pluralize().toLowerCase()], true

    fixtures = FixtureSet.create(store: store).loadAll()
    fixtures

