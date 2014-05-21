app = angular.module 'consulted.history.controllers', [
  'consulted.history.services'
  'consulted.history.filters'
  'consulted.overview'
]

app.controller 'TabsCtrl', [
  '$scope'
  'Type'
  (scope, Type) ->
    scope.offered       = () -> Type.isOffered()
    scope.showRequested = () -> Type.setRequested()
    scope.showOffered   = () -> Type.setOffered()
]

app.controller 'CallsCtrl', [
  '$scope'
  'Calls'
  'Type'
  '$filter'
  (scope, Calls, Type, filter) ->
    status = 1
    _calls = null

    scope.offered = -> Type.isOffered()
    scope.isStatus  = (number) -> number is status
    scope.setStatus = (number) -> status = number
    scope.calls = -> filter('status')(_calls, status)

    scope.$on 'reload:calls', -> fetch()

    fetch = () ->
      scope.loading = yes
      if Type.isOffered()
        calls = Calls.getOffered()
      else
        calls = Calls.getRequested()

      calls.then (data) ->
        _calls = data
      , () ->
        scope.error = yes
      .finally () ->
        scope.loading = no

    fetch()

    scope.confirm
]
