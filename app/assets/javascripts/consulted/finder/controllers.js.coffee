app = angular.module 'consulted.finder.controllers', [
  'consulted.finder.services'
]

app.controller 'FilterCtrl', [
  '$scope'
  'Language'
  'Continent'
  FilterCtrl = (scope, Language, Continent) ->
    slice = (arr, elipsis = '...') ->
      display = arr.slice 0, 2
      display.push elipsis if display.length < arr.length
      display

    scope.currentLocations = -> slice Continent.getCurrent()
    scope.currentLanguages = -> slice Language.getCurrent()
]
