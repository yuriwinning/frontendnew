Radium.ChecklistItemMixin = Ember.Mixin.create(Ember.TargetActionSupport,
  classNameBindings: ['isInvalid']
  insertNewline: (e) ->
    @get('parentView').createNewItem()
)

Radium.ChecklistView = Ember.View.extend
  templateName: 'deals/checklist'
  checklist: Ember.computed.alias 'controller.checklist'

  newItemDescription: Ember.TextField.extend Radium.ChecklistItemMixin,
    valueBinding: 'controller.newItemDescription'
    placeholder: "Add additional item"

  newItemWeight: Ember.TextField.extend Radium.ChecklistItemMixin,
    attributeBindings: ['min', 'max']
    valueBinding: 'controller.newItemWeight'
    placeholder: 0

  showAddButton: ( ->
    description = @get('controller.newItemDescription')
    weight = @get('controller.newItemWeight')

    return unless /^\d+$/.test weight
    return unless parseInt(weight) <= 100 && parseInt(weight) > 0

    (description.length > 0)
  ).property('controller.newItemDescription', 'controller.newItemWeight')

  createNewItem: ->
    description = @get('controller.newItemDescription')
    weight = parseInt(@get('controller.newItemWeight'))
    finished = @get('controller.newItemFinished')
    return if Ember.isEmpty(description)
    return if Ember.isEmpty(weight)

    checklist = @get('checklist')

    newItem =
            description: description
            weight: weight
            isFinished: true
            kind: 'additional'
            checklist: checklist

    newRecord = if @get('controller.isNew')
                  Ember.Object.create(newItem)
                else
                  @get('checklist.checklistItems').createRecord(newItem)

    if @get('controller.isNew')
      @get('checklist.checklistItems').addObject newRecord

    @set('controller.newItemDescription', '')
    @set('controller.newItemWeight', '')
    @set('controller.newItemFinished',false)
    @get('itemDescription').$().focus()
