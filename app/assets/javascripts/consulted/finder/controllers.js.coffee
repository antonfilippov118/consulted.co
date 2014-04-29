app = angular.module 'consulted.finder.controllers', [
  'consulted.finder.services'
]

app.controller 'FilterCtrl', [
  '$scope'
  'Language'
  'Continent'
  'Rate'
  'Experience'
  FilterCtrl = (scope, Language, Continent, Rate, Experience) ->
    slice = (arr, elipsis = '...') ->
      display = arr.slice 0, 2
      display.push elipsis if display.length < arr.length
      display

    scope.currentLocations  = -> slice Continent.getCurrent()
    scope.currentLanguages  = -> slice Language.getCurrent()
    scope.currentRate       = -> Rate.getCurrent()
    scope.currentExperience = -> Experience.getCurrent()
    scope.currentDays       = -> []
]

app.controller 'ResultCtrl', [
  '$scope'
  'Search'
  '$rootScope'
  (scope, Search, rootScope) ->
    Search.trigger({}, yes)

    rootScope.$on 'result', (_, result) ->
      scope.result = result

]
