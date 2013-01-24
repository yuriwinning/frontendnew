Radium = Em.Application.create
  autoinit: false
  rootElement: '#application'

window.Radium = Radium

# First off, require all the custom additions and code
# we need to be available globally
require 'ember/datetime'
require 'string/inflector'

require 'foundry'
require 'ember/filterable_mixin'

require 'radium/run_when_loaded_mixin'

require 'radium/utils'

require 'radium/store'

require 'radium/router'

require 'radium/mixins'

require 'radium/models'

require 'radium/views'

require 'radium/checkable_mixin'
require 'radium/selectable_mixin'

requireAll /radium\/controllers/


require /radium\/helpers/

require 'radium/factories'
