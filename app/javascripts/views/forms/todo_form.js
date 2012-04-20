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
        finishByDate = this.$('#finish-by-date').val(),
        finishByTime = this.$('#finish-by-time').val(),
        finishByMeridian = this.$('#finish-by-meridian').val(),
        finishByValue = this.timeFormatter(finishByDate, finishByTime, finishByMeridian),
        userId = this.$('select#assigned-to').val(),
        data = {
          todo: {
            description: description,
            finish_by: finishByValue,
            user_id: userId
          }
        };

    // Disable the form buttons
    this.sending();
    
    var userSettings = {
          url: '/api/todos'.fmt(userId),
          type: 'POST',
          data: JSON.stringify(data)
        },
        userRequest = jQuery.extend(userSettings, CONFIG.ajax);

    $.ajax(userRequest)
      .success(function(data) {
        self.success("Todo created");
      })
      .error(function(jqXHR, textStatus, errorThrown) {
        self.error("Oops, %@.".fmt(jqXHR.responseText));
      });

    if (contactIds.length) {
      contactIds.forEach(function(id) {
        var settings = {
              url: '/api/contacts/%@/todos'.fmt(id),
              type: 'POST',
              data: JSON.stringify(data)
            },
            request = jQuery.extend(settings, CONFIG.ajax);

        $.ajax(request)
          .success(function(data) {
            self.success("Todo created");
          })
          .error(function(jqXHR, textStatus, errorThrown) {
            self.error("Oops, %@.".fmt(jqXHR.responseText));
          });
      });
    }
  }
});