Radium.MeetingAttendeesView = Radium.View.extend
  actions:
    showContextMenu: ->
      return false unless @get('isEditable')

      el = @$()

      dropdown = el.find('.contextMenu')

      dropdown.toggleClass('open')

      event.preventDefault()
      event.stopPropagation()

  isEditable: Ember.computed.not 'controller.isNew'
  tagName: 'li'
  attributeBindings: ['controller.displayName:title']

  didInsertElement: ->
    @_super.apply this, arguments

    $('body').on 'click.attendees-view', (e) =>
      @$().find('.contextMenu').removeClass('open')
      e.stopPropagation()
      e.preventDefault()

  willDestroyElement: ->
    @_super.apply this, arguments
    $('body').off 'click.attendees-view'

  click: (e) ->
    dropdown = @$().find('.contextMenu')[0]

    @$().parent().find('.contextMenu').each (index, el)  =>
      $(el).removeClass('open') unless el == dropdown

    return false unless @get('isEditable')
    @send 'showContextMenu', @get('controller.model')

  template: Ember.Handlebars.compile """
      {{#if isLoaded}}
        {{avatar this style="medium"}}
        {{#unless isInvited}}
          <a href="#" class="btn-close" {{action removeSelection this}}>&times;</a>
        {{/unless}}
      {{else}}
        {{partial 'is_loading'}}
      {{/if}}
      <div class="contextMenu dropdown">
        <a class="dropdown-toggle needsclick" href="#">
          link<b class="caret"></b>
        </a>
        <div class="attendeeMenu dropdown-menu">
          <table>
            <tr>
              <td><a href="#" {{action cancelInvitation this}}>Remove Attendee</a></td>
              <td><a href="#" {{action resendInvite this}}>Resend Invite</a></td>
            </tr>
          </table>
        </div>
      </div>
    """
