Radium.Radiobutton =  Ember.View.extend
  leader: 'field'
  selectedValue: null
  template: Ember.Handlebars.compile """
    <input type="radio" {{bind-attr name="view.name"}} {{bind-attr value="view.value"}} id="{{unbound view.radioId}}" {{bind-attr checked=view.isChecked}} {{bind-attr disabled=view.disabled}}/>
    <label class="capitalize" for="{{unbound view.radioId}}">{{unbound view.leader}}</label>
  """

  didInsertElement: ->
    @selectedValueDidChange()

  radioId: ( ->
    "radio-#{@get('elementId')}"
  ).property()

  selectedValueDidChange: ( ->
    selectedValue = @get('selectedValue')
    radio = @$('input[type=radio]')
    value = radio.val()

    if !Ember.isEmpty(selectedValue) && selectedValue == value
      radio.prop('checked', true)
      @updateElementValue()
    else
      radio.prop('checked', false)
  ).observes('selectedValue')

  change: (evt) ->
    radio = @$('input[type=radio]')
    radio.attr('checked', true)
    @updateElementValue()

  updateElementValue: ->
    radio = @$('input[type=radio]')
    return unless radio.attr('checked')
    @set 'selectedValue', radio.val()
