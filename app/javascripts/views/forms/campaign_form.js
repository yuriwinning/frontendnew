  Radium.CampaignForm = Radium.FormView.extend({
    selectedContactsBinding: 'Radium.contactsController.selectedContacts',
    templateName: 'campaign_form',

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
          name = this.$('#campaign-name').val(),
          target = this.$('#target').val(),
          endsByDate = this.$('#ends-by-date').val().split('-'),
          endsByTime = this.$('#ends-by-time').val().split(':'),
          currency = this.$('#currency').val(),
          description = this.$('#description').val(),
          user = this.$('select#assigned-to').val(),
          data = {
            campaign: {
              name: name,
              description: description,
              target: target,
              ends_at: Ember.DateTime.create({
                year: endsByDate[0],
                month: endsByDate[1],
                day: endsByDate[2],
                hour: endsByTime[0],
                minute: endsByTime[1]
              }).toISO8601(),
              user_id: user,
              contact_ids: contactIds,
              currency: currency
            }
          };

      // Disable the form buttons
      this.sending();
      
    
      $.ajax({
        url: '/api/campaigns',
        type: 'POST',
        data: data,
        success: function(data) {
          self.success("Campaign created");
        },
        error: function(jqXHR, textstate, errorThrown) {
          self.error("Oops, %@.".fmt(jqXHR.responseText));
        }
      });
    
    }
  });