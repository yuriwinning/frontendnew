Ember.DateTime.reopen
  toDateFormat: ->
    @toFormattedString('%Y-%m-%d')

  toFullFormat: ->
    @toISO8601()

  isBetween: (start, end) ->
    return false if Ember.DateTime.compareDate(this, start) == -1
    return false if Ember.DateTime.compareDate(this, end) == 1
    true

  atEndOfDay: ->
    @adjust hour: 23, minute: 59, second: 59

  atBeginningOfDay: ->
    @adjust hour: 0, minute: 0, second: 0 

Ember.DateTime.reopenClass
  random: ->
    multipler = ->
     if Math.random() > 0.5 then 1 else -1

    randomUpTo = (max) ->
      Math.floor((Math.random() * max) + 1)

    @create().advance
      day: randomUpTo(180) * multipler()
      hour: randomUpTo(24) * multipler()
      minute: randomUpTo(60) * multipler()
