app = angular.module 'consulted.finder.controllers', [
  'consulted.finder.services'
  'ui.bootstrap'
]

app.controller 'FilterCtrl', [
  '$scope'
  'Language'
  'Continent'
  'Rate'
  'Experience'
  'Date'
  'Time'
  'Bookmark'
  'Tag'
  FilterCtrl = (scope, Language, Continent, Rate, Experience, Date, Time, Bookmark, Tag) ->
    scope.open = no

    scope.toggle = () ->
      scope.open = !scope.open
      scope.$broadcast 'open', scope.open

    slice = (arr, elipsis = '...') ->
      display = arr.slice 0, 2
      display.push elipsis if display.length < arr.length
      display

    scope.currentLocations  = -> slice Continent.getCurrent()
    scope.currentLanguages  = -> slice Language.getCurrent()
    scope.currentRate       = -> Rate.getCurrent()
    scope.currentExperience = -> Experience.getCurrent()
    scope.currentDays       = -> slice Date.getCurrent()
    scope.bookmarksOnly     = -> Bookmark.isActive()
    scope.currentTags       = -> slice Tag.getCurrent()
    scope.currentTimes      = ->
      slice do ->
        Time.getCurrent().sort((a, b) ->
          a.from - b.from
        ).map (obj) -> obj.name
]

app.controller 'ResultCtrl', [
  '$scope'
  'Search'
  (scope, Search) ->
    Search.do({})

    scope.$on 'searching', (_, bool) ->
      scope.searching = bool

    scope.$on 'result', (_, result) ->
      scope.offers = result
]
