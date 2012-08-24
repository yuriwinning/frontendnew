#  Core model class for all Radium models. Base attributes are `created_at` and `updated_at`

Radium.Core = DS.Model.extend
  createdAt: DS.attr("datetime", key: "created_at")
  updatedAt: DS.attr("datetime", key: "updated_at")
  type: (->
    parts = @constructor.toString().split('.')
    type = parts[parts.length - 1]
    return type.replace(/([A-Z])/g, '_$1').toLowerCase().slice(1);
  ).property()
  domClass: (->
    "#{@get('type')}_#{@get('id')}"
  ).property('type', 'id')

Radium.Core.typeFromString = (str) ->
  type = str.replace /_([a-z])|^([a-z])/g, (match, p1, p2) -> (p1 || p2).toUpperCase()
  Radium[type]
