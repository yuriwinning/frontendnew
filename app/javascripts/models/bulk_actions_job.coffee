Radium.BulkActionsJob = Radium.Model.extend
  action: DS.attr('string')
  ids: DS.attr('array')
  user: DS.belongsTo('Radium.User')
  tag: DS.belongsTo('Radium.Tag')
  public: DS.attr('boolean')
  newTags: DS.attr('array')
  filter: DS.attr('string')
  like: DS.attr('string')