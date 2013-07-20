Day = Ember.ArrayProxy.extend()

Radium.CalendarSidebarController = Radium.ObjectController.extend
  needs: ['calendar', 'calendarSidebar']
  contentBinding: 'controllers.calendar.user'
  isLoading: Ember.computed.alias 'controllers.calendar.isLoading'

  selectedTask: null
  selectedDay: null

  items: (->
    @get 'controllers.calendar.items'
  ).property('controllers.calendar.items')

  date: (->
    @get 'controllers.calendar.date'
  ).property('controllers.calendar.date')

  isDifferentUser: (->
    @get('content') != @get('currentUser')
  ).property('content', 'currentUser')

  startOfCalendar: (->
    @get('date').copy().atBeginningOfMonth()
  ).property('date')

  endOfCalendar: (->
    @get('date').copy().atEndOfMonth()
  ).property('date')

  days: (->
    days = []
    items = @get 'items'
    startDate = @get 'startOfCalendar'
    endDate = @get 'endOfCalendar'

    dates = @get('items').filter((i) ->
      i.get('time').isBetweenDates(startDate, endDate)
    ).map((i) -> 
      i.get('time').toDateFormat()
    ).uniq()

    dates.forEach (date) ->
      dailyItems = items.filter (item) -> item.get('time').toDateFormat() == date

      day = Day.create 
        content: dailyItems
        date: dailyItems.get('firstObject.time')

      days.pushObject day

    days
  ).property('items')
