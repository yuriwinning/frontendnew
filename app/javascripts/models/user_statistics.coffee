Radium.UserStatistics = Radium.Model.extend
  user: DS.belongsTo('Radium.User')
  closedDeals: DS.attr('number')
  inPipeline: DS.attr('number')
  emailsSent: DS.attr('number')
  meetingsCreated: DS.attr('number')
  averageClosedDealSize: DS.attr('number')
  contactsAdded: DS.attr('number')
  activePipelineTotal: DS.attr('number')