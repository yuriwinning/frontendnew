Radium.User = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  account: DS.belongsTo('Radium.Account')
  contacts: DS.hasMany('Radium.Contact')
  deals: DS.hasMany('Radium.Deal')

  todos: DS.hasMany('Radium.Todo', inverse: 'user')
  calls: DS.hasMany('Radium.Call', inverse: 'user')
  meetings: DS.hasMany('Radium.Meeting', inverse: 'users')

  activities: DS.hasMany('Radium.Activity', inverse: 'user')

  firstName: DS.attr('string')
  lastName: DS.attr('string')
  title: DS.attr('string')

  following: DS.hasMany('Radium.User')

  email: DS.attr('string')
  phone: DS.attr('string')

  # avatar: DS.attr('object')

  # settings: DS.attr('object')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  salesGoal: DS.attr('number')

  name: ( ->
    "#{@get("firstName")} #{@get("lastName")}"
  ).property('firstName', 'lastName')

  leads: ( ->
    @get('contacts').filterProperty 'status', 'lead'
  ).property('contact.[]'),

  negotiatingDeals: ( ->
    @get('deals').filter (deal) ->
      deal.get('status') != 'closed' || deal.get('status') != 'lost'
  ).property('deals.[]')

  closedDeals: ( ->
    @get('deals').filterProperty 'status', 'closed'
  ).property('deals.[]')

  lostDeals: ( ->
    @get('deals').filterProperty 'status', 'lost'
  ).property('deals.[]')

Radium.User.reopenClass
  current: ->
    Radium.User.find(name: 'me')
