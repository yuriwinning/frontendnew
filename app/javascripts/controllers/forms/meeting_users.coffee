Radium.MeetingUsers = Ember.ArrayProxy.extend
  content: []
  meetings: []
  startsAt: null

  startsAtDidChange: ( ->
    return unless @get('startsAt') && @get('content.length')
    @get('meetings').clear()

    @forEach (user) =>
      @findMeetingsForUser(user)
  ).observes('startsAt')

  arrayContentDidChange: (startIdx, removeAmt, addAmt) ->
    @_super.apply this, arguments

    if addAmt > 0
      @findMeetingsForUser @objectAt(startIdx)

  arrayContentWillChange: (startIdx, removeAmt, addAmt) ->
    if removeAmt > 0
      @removeMeetingsForUser @objectAt(startIdx)

    @_super.apply this, arguments

  findMeetingsForUser: (user) ->
    return unless @get('startsAt')

    meetings = Radium.Meeting.find(user: user, day: @get('startsAt'))
                              .filter (meeting) ->
                                return false if meeting.get('isNew') || !meeting.get('users.length')
                                meeting.get('users').contains(user)

    self = this

    meetings.forEach (meeting) ->
      meeting.get('users').forEach (user) ->
        if self.contains(user)
          existingEntry = self.get('meetings').find (existing) ->
            existing.get('content') == meeting && existing.get('selectedUser') == user

          unless existingEntry
            meetingItem = Radium.MeetingItem.create
              content: meeting
              selectedUser: user

            self.get('meetings').pushObject(meetingItem)

  removeMeetingsForUser: (user) ->
    meetings = @get('meetings')

    meetings.forEach (meeting) ->
      meetings.removeObject(meeting) if meeting.get('users').contains(user)
