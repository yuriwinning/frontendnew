Radium.TodoForm = Radium.FormView.extend(Radium.FormReminder, {
  wantsReminder: false,
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  templateName: 'todo_form',

  findContactsField: Radium.AutocompleteTextField.extend({
    select: function(event, ui) {
      var contact = Radium.store.find(Radium.Contact, ui.item.value);
      contact.set('isSelected', true);
      this.$().val('');
    }
  }),

  submitForm: function() {
    var self = this;
    var contactIds = this.get('selectedContacts').getEach('id'),
        description = this.$('#description').val(),
        finishByDate = this.$('#finish-by-date').val().split('-'),
        finishByTime = this.$('#finish-by-time').val().split(':'),
        user = this.$('select#assigned-to').val(),
        data = {
          todo: {
            description: description,
            finish_by: Ember.DateTime.create({
              year: finishByDate[0],
              month: finishByDate[1],
              day: finishByDate[2],
              hour: finishByTime[0],
              minute: finishByTime[1]
            }).toISO8601(),
            user_id: user
          }
        };

    // Disable the form buttons
    this.sending();
    
    contactIds.forEach(function(id) {
      $.ajax({
        url: '/api/contacts/%@/todos'.fmt(id),
        type: 'POST',
        data: data,
        success: function(data) {
          self.success("Todo created");
        },
        error: function(jqXHR, textStatus, errorThrown) {
          self.error("Oops, %@.".fmt(jqXHR.responseText));
        }
      });
    });
  }
});