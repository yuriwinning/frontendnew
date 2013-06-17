Radium.PeopleList = Ember.ArrayProxy.extend
  init: ->
    @set 'content', Ember.A()
    @_super.apply this, arguments

  list: ->
    users = if @get('users.length') then @get('users').toArray() else []
    contacts = if @get('contacts.length') then @get('contacts').toArray() else []
    users.concat(contacts)
    .filter((person) -> person.get('email') || person.get('primaryEmail.value'))
    .sort(@comparer)

  comparer: (a, b) ->
    sortA = a.get('name') || a.get('email') || a.get('primaryEmail.value')
    sortB = b.get('name') || b.get('email') || b.get('primaryEmail.value')

    if sortA > sortB
     return 1
    else if sortA < sortB
     return - 1

    0

Radium.PeopleList.reopenClass
  listPeople: (users, contacts) ->
    result = Radium.PeopleList.create()
    result.set 'users', users
    result.set 'contacts', contacts

    result.list()
