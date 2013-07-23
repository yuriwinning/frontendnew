require 'forms/form'

Radium.TodoForm = Radium.Form.extend
  data: ( ->
    user: @get('user')
    finishBy: @get('finishBy')
    reference: @get('reference')
    description: @get('description')
  ).property().volatile()

  type: ( ->
    if this.constructor is Radium.TodoForm then Radium.Todo else Radium.Call
  ).property()

  typeName: ( ->
    @get('type').toString().humanize()
  ).property('type')

  reset: ->
    @_super.apply this, arguments
    @set 'description', ''

  isBulk: ( ->
    Ember.isArray @get('reference')
  ).property('reference')

  commit: ->
    promise = Ember.Deferred.promise (deferred) =>
      isBulk = Ember.isArray @get('reference')

      if isBulk
        @bulkCommit(deferred)
      else
        @individualCommit(deferred)

      @get('store').commit()

    promise

  individualCommit: (deferred) ->
    return unless @get('isNew')

    record = @get('type').createRecord @get('data')

    record.one 'didCreate', =>
      deferred.resolve()

    record.one 'becameInvalid', (result) =>
      deferred.reject(result)

    record.one 'becameError', (result)  ->
      result.get('transaction').rollback()
      typeName = @get('type').toString().humanize()
      deferred.reject("An error has occurred and the #{typeName} could not be created.")

  bulkCommit: ->
    typeName = @get('type').toString().humanize()

    @get('reference').forEach (item) =>
      record = @get('type').createRecord @get('data')
      record.set 'reference', item

      record.one 'didCreate', (record) =>
        if item == @get('reference.lastObject')
          deferred.resolve("The todos have been created")

      record.one 'becameInvalid', (result) =>
        deferred.reject(result)

      record.one 'becameError', (result)  ->
        deferred.reject("An error has occurred and the #{typeName} could not be created.")
