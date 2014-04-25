app = angular.module 'consulted.finder', [
  'consulted.finder.services'
  'consulted.finder.directives'
  'consulted.common'
]

app.run [
  'Configuration'
  '$rootElement'
  (Configuration, root) ->
    group = root.data 'group'
    throw 'Cannot be initialized without a service offering!' unless group
    Configuration.setGroup group
]