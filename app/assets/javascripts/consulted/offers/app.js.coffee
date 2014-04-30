app = angular.module 'consulted.offers', [
  'consulted.offers.directives'
]

app.run [
  '$rootElement'
  ($rootElement) ->
    newEl = $('<div categories></div>')
    $rootElement.append newEl

    newEl = $('<div editor></div>')
    $rootElement.append newEl
]

