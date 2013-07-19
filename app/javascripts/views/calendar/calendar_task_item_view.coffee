Radium.CalendarTaskItemView = Radium.View.extend
  classNames: 'events-list-item'
  classNameBindings: ['controller.isSelected']
  templateName: 'calendar/calendar_task_item'

  isSelectedDidChange: ( ->
    return unless @get('controller.isSelected')

    Ember.run.scheduleOnce 'afterRender', this, 'scrollToTask'
  ).observes('controller.isSelected')

  scrollToTask: ->
    self = this

    $('html, body').animate(
      scrollTop: self.$().offset().top - self.$().height()
    , 500)