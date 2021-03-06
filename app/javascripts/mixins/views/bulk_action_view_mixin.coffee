require 'views/forms/todo_field_view'

Radium.BulkActionViewMixin = Ember.Mixin.create
  didInsertElement: ->
    @_super.apply this, arguments
    @get('controller').on('formReset', this, 'onFormReset') if @get('controller').on

  onFormReset: ->
    if @$('.action-forms form')
      @$('.action-forms form').each  ->
        @reset()

  assignTodoField: Radium.FormsTodoFieldView.extend
    valueBinding: 'controller.reassignTodo'
    placeholder: "Add related todo?"
    keyDown: (e) ->
      unless e.keyCode == 13
        @_super.apply this, arguments
        return

      @get('controller').send 'reassign'

      e.preventDefault()
      e.stopPropagation()
      false


