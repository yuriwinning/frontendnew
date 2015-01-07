Radium.ContactColumnsConfig = Ember.Mixin.create
  SAVED_COLUMNS: "saved_checked_columns"
  initialColumns: ['email', 'company', "events", "inactive", "next-task", "next-task-date", "assign"]
  fixedColumns: Ember.A([
    {
      classNames: "name"
      heading: "Name"
      route: "contact"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Name",
        static: true
      },
      {
        name: "bufferKey",
        value: "name"
        static: true
      }]
      avatar: true
      checked: true
      sortOn: "name"
      component: 'editable-field'
    }
  ])

  columns: Ember.A([
    {
      id: "email"
      classNames: "email"
      heading: "Email"
      route: "contact"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Email",
        static: true
      },
      {
        name: "bufferKey",
        value: "email"
        static: true
      },
      {
        name: 'validator',
        value: Radium.EMAIL_REGEX,
        static: true
      }],
      actions: [
        name: "saveEmail"
        value: "saveEmail"
      ]
      sortOn: "email"
      component: 'editable-field'
    }
    {
      id: "company"
      classNames: "company"
      heading: "Company"
      route: "company"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Company",
        static: true
      },
      {
        name: "bufferKey",
        value: "companyName"
        static: true
      },
      {
        name: "queryKey",
        value: "name",
        static: true
      },
      {
        name: "alternativeRoute",
        value: "company",
        static: true
      },
      {
        name: 'scopes'
        value: 'company'
        static: true
      }],
      actions: [
        {
          name: "saveCompanyName"
          value: "saveCompanyName"
        }
      ]
      context: "company"
      sortOn: "company"
      component: 'autocomplete-editable-field'
    }
    {
      id: "events"
      classNames: "events"
      heading: "Events"
      binding: "activityTotal"
      sortOn: "activity_total"
    }
    {
      id: "inactive"
      classNames: "inactive"
      heading: "Inactive"
      binding: "daysInactive"
      sortOn: "last_activity_at"
    }
    {
      id: "next-task"
      classNames: "next-task"
      heading: "Next Task"
      route: "calendar.task"
      context: "nextTask"
      bindings: [{
        name: "model"
        value: "model"
      }
      {
        name: "currentUser"
        value: "currentUser"
      }
      {
        name: "tomorrow"
        value: "tomorrow"
      }]
      component: "next-task"
    }
    {
      id: "next-task-date"
      classNames: "next-task-date"
      heading: "Next Task Date"
      binding: "nextTaskDateDisplay"
      checked: true
      sortOn: "next_task_date"
    }
    {
      id: "assign"
      classNames: "assign"
      heading: "Assigned To"
      component: "assignto-picker"
      bindings: [
        {name: "assignedTo", value: "assignedTo"},
        {name: "assignees", value: "assignees"},
        {name: "contact", value: "contact"},
      ]
    }
    {
      id: "last-activity"
      classNames: "last-activity"
      heading: "Last Activity"
      component: "render-activity"
      bindings: [
        {name: "model", value: "model.activities.firstObject"}
      ]
    }
    {
      id: "city"
      classNames: "city"
      heading: "City"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add city",
        static: true
      },
      {
        name: "bufferKey",
        value: "city"
        static: true
      }
      ],
      actions: [
        {
          name: 'saveCity'
          value: 'saveCity'
          static: true
        }
      ]
      sortOn: "city"
      component: 'editable-field'
    }
    {
      id: "phone"
      classNames: "phone"
      heading: "Phone"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Phone",
        static: true
      },
      {
        name: "bufferKey",
        value: "phone"
        static: true
      }
      ],
      actions: [
        {
          name: 'savePhone'
          value: 'savePhone'
          static: true
        }
      ]
      sortOn: "phone"
      component: 'editable-field'
    }
    {
      id: "source"
      classNames: "source"
      heading: "Source"
      binding: "source"
      sortOn: "source"
    }
    {
      id: "added"
      classNames: "added"
      heading: "Added"
      binding: "added"
      sortOn: "created_at"
    }
    {
      id: "deals-closed-total"
      classNames: "deals-closed-total"
      heading: "Deals Closed"
      binding: "dealsClosedTotal"
      sortOn: "deals_closed_total"
    }
    {
      id: "deals-total"
      classNames: "deals-total"
      heading: "Deals Total"
      binding: "dealsTotal"
      sortOn: "deals_closed_total_value"
    }
    {
      id: "tags"
      classNames: "tags"
      heading: "Lists"
      bindings: [
        {name: "model", value: "model"}
      ]
      component: "tag-picker"
    }
    {
      id: "status"
      classNames: "status"
      heading: "Status"
      binding: "status"
      sortOn: "status"
    }
    {
      id: "events-seven"
      classNames: "events-seven"
      heading: "Events in last 7 days"
      binding: "activitySevenDaysTotal"
      sortOn: "activity_seven_days_total"
    }
    {
      id: "events-thirty"
      classNames: "events-thirty"
      heading: "Events in last 30 days"
      binding: "activityThirtyDaysTotal"
      sortOn: "activity_thirty_days_total"
    }
  ])