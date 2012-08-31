test 'feed sections with dates should be displayed', ->
  expect(1)

  section = F.feed_sections('default')

  waitForResource section, ->
    headers = $('#feed .page-header h3')
    assertContains headers, 'Friday, August 17, 2012.*Tuesday, August 14, 2012'

test 'feed sections should contain todo items', ->
  expect(1)

  todo = F.todos('default')

  waitForResource todo, (el) ->
    assertContains el, 'Finish first product draft'

test 'when scrolling back, feed loads older items', ->
  controller = Radium.get('router.feedController')

  assertContains 'Friday, August 17, 2012.*Tuesday, August 14, 2012'
  assertNotContains 'Sunday, July 15, 2012'
  assertNotContains 'Saturday, July 14, 2012'

  controller.loadFeed back: true

  section = F.feed_sections('feed_section_3')
  waitForResource section, ->
    assertContains 'Sunday, July 15, 2012'
    assertContains 'Saturday, July 14, 2012'

test 'when scrolling forward, feed loads newer items', ->
  Ember.run ->
    Radium.get('router').transitionTo('dashboardWithDate', date: '2012-07-14')

  section = F.feed_sections('feed_section_4')
  waitForResource section, ->
    controller = Radium.get('router.feedController')
    controller.loadFeed forward: true
    section = F.feed_sections('default')
    waitForResource section, ->
      assertContains 'Friday, August 17, 2012'
