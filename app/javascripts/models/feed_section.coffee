Radium.FeedSection = Radium.Core.extend
  date: DS.attr('datetime')
  nextDate: DS.attr('string')
  previousDate: DS.attr('string')
  items: Radium.ClusteredRecordArray.attr(key: 'item_ids')

  pushItem: (item) ->
    @get('items').pushObject(item) unless @contains(item)

  contains: (item) ->
    @get('items').contains(item)
