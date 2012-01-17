define('testdir/models/contact.spec', function(require) {
  var RadiumAdapter = require('adapter'),
      Radium = require('radium');

  var get = Ember.get, set = Ember.set, getPath = Ember.getPath;

  var USER_FIXTURE = {
    id: 100,
    name: "Jimmy McNulty",
    phone: "+1 410 555-5555",
    contacts: [1]
  };

  var NEW_USER_FIXTURE = {
    id: 101,
    name: "Bunk Moreland",
    phone: "+1 410 555-6666",
    contacts: []
  };

  var CONTACT_FIXTURE = {
        id: 1,
        name: "Stringer Bell",
        user: 100,
        addresses: [{
            id: 8,
            name: "Address 1",
            street: "03284 Johnson Center",
            state: "Illinois",
            country: "United States",
            zip_code: "39645",
            time_zone: null
        }],
        phone_numbers: [{
            id: 282,
            name: "Phone Number",
            value: "+52313872481",
            accepted_values: null
        }],
        email_addresses: [{
            id: 281,
            name: "Email",
            value: "email-1@example.com",
            accepted_values: null,
        }],
        fields: [{
          id: 285,
          created_at: "2011-12-14T19:12:30Z",
          updated_at: "2011-12-14T19:12:30Z",
          name: "Industry",
          value: "Real Estate Development",
          accepted_values: null,
          kind: "other"
        },
        {
          id: 284,
          created_at: "2011-12-14T19:12:28Z",
          updated_at: "2011-12-14T19:12:28Z",
          name: "Industry",
          value: "Auto Parts Stores",
          accepted_values: null,
          kind: "other"
        },
        {
          id: 283,
          created_at: "2011-12-14T19:12:25Z",
          updated_at: "2011-12-14T19:12:25Z",
          name: "Industry",
          value: "Property & Casualty Insurance",
          accepted_values: null,
          kind: "other"
        }]
  };

  describe("Radium#Contact", function() {
    
    it("inherits from Radium.Person", function() {
      expect(Radium.Person.detect(Radium.Contact)).toBeTruthy();
    });
    
    describe("creating a new contact", function() {
      var contact;

      beforeEach(function() {
        contact = Radium.Contact.create(CONTACT_FIXTURE)
      });
      
      afterEach(function() {
        contact.destroy();
      });
      
      it("creates a user", function() {
        expect(contact).toBeDefined();
      });
      
      it("loads and processes their name", function() {
        expect(contact.get('name')).toBe("Stringer Bell");
        expect(contact.get('firstName')).toBe("Stringer");
        expect(contact.get('abbrName')).toBe("Stringer B.");
      });
    
    });

    describe("when talking with the API", function() {
      var adapter, store, server;

      beforeEach(function() {
        adapter = RadiumAdapter.create();
        store = DS.Store.create({adapter: adapter});
        server = sinon.fakeServer.create();
      });
      
      afterEach(function() {
        adapter.destroy();
        store.destroy();
        server.restore();
        server.fakeHTTPMethods = false;
        jQuery.ajax.restore();
      });

      it("loads a user that exists", function() {
        var spy, contact;
        
        spy = sinon.spy(jQuery, 'ajax');

        server.respondWith("GET", "/contacts/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(CONTACT_FIXTURE)
        ]);
        
        contact = store.find(Radium.Contact, 1);
        server.respond();
        
        expect(spy).toHaveBeenCalled();
        expect(contact.get('name')).toBe("Stringer Bell");
      });
      // TODO: Implement this test once Ember-Data supports modifying nested records
      it("assigns a contact to a different user", function() {
        var spy, user1, user2, contact, updatedFixture;

        updatedFixture = CONTACT_FIXTURE;
        updatedFixture = 101;

        server.fakeHTTPMethods = true;
        spy = sinon.spy(jQuery, 'ajax');

        server.respondWith("POST", "/contacts/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(updatedFixture)
        ]);

        store.loadMany(Radium.User, [
          USER_FIXTURE,
          NEW_USER_FIXTURE
        ]);

        store.load(Radium.Contact, CONTACT_FIXTURE);

        user1 = store.find(Radium.User, 100);
        user2 = store.find(Radium.User, 101);
        contact = store.find(Radium.Contact, 1);
        

        set(contact, 'user', 101);

        store.commit();
        server.respond();

        // expect(spy).toHaveBeenCalled();
        // expect(contact.get('user')).toEqual(user2);
      });
    });

    describe("when nested attributes are requested", function() {
      beforeEach(function() {
        adapter = RadiumAdapter.create();
        store = DS.Store.create({adapter: adapter});
        server = sinon.fakeServer.create();
        server.respondWith("GET", "/contacts/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(CONTACT_FIXTURE)
        ]);
      });
      
      afterEach(function() {
        adapter.destroy();
        store.destroy();
        server.restore();
        jQuery.ajax.restore();
      });

      it("loads nested Radium.Address", function() {
        var spy, contact;
        
        spy = sinon.spy(jQuery, 'ajax');

        contact = store.find(Radium.Contact, 1);
        server.respond();
        
        expect(spy).toHaveBeenCalled();
        expect(contact.get('addresses').objectAt(0).get('id')).toEqual(8);
      });

      it("loads nested Radium.PhoneNumber", function() {
        var spy, contact;
        
        spy = sinon.spy(jQuery, 'ajax');

        contact = store.find(Radium.Contact, 1);
        server.respond();
        
        expect(spy).toHaveBeenCalled();
        expect(contact.get('phoneNumbers').objectAt(0).get('id'))
          .toEqual(282);
      });

      it("loads nested Radium.PhoneNumber", function() {
        var spy, contact;
        
        spy = sinon.spy(jQuery, 'ajax');

        contact = store.find(Radium.Contact, 1);
        server.respond();
        
        expect(spy).toHaveBeenCalled();
        expect(contact.get('emailAddresses').objectAt(0).get('id'))
          .toEqual(281);
      });

      it("loads nested Radium.Field", function() {
        var spy, contact;
        
        spy = sinon.spy(jQuery, 'ajax');

        contact = store.find(Radium.Contact, 1);
        server.respond();
        
        expect(spy).toHaveBeenCalled();
        expect(contact.getPath('fields.length')).toEqual(3);
        expect(contact.get('fields').getEach('id'))
          .toEqual([285, 284, 283]);
      });
    });

    describe("when adding a new nested item", function() {
      beforeEach(function() {
        adapter = RadiumAdapter.create();
        server.fakeHTTPMethods = true;
        store = DS.Store.create({adapter: adapter});
        server = sinon.fakeServer.create();
      });
      
      afterEach(function() {
        adapter.destroy();
        store.destroy();
        server.restore();
        jQuery.ajax.restore();
      });

      it("adds a new phone number", function() {
        var spy, newPhone, contact;
        spy = sinon.spy(jQuery, 'ajax');

        server.respondWith("PUT", "/contacts/1", [
          200, 
          {"Content-Type": "application/json"},
          JSON.stringify(CONTACT_FIXTURE) 
        ]);

        contact = store.find(Radium.Contact, 1);

        newPhone = store.createRecord(Radium.EmailAddress, {
          name: "Home Phone",
          value: "+410 444 4442"
        });

        contact.get('emailAddresses').pushObject(newPhone);

        expect(contact.getPath('emailAddresses.length')).toEqual(2);
        expect(newPhone.get('isNew')).toBeTruthy();

        store.commit();
        server.respond();
        expect(spy).toHaveBeenCalled();

      });

    });
    
  });

});