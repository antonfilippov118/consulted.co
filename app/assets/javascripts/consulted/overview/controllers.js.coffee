app = angular.module 'consulted.overview.controllers', [
  'consulted.overview.services'
  'consulted.overview.filters'
  'ui.bootstrap'
]

app.controller 'TableCtrl', [
  '$scope'
  'Call'
  '$timeout'
  '$filter'
  TableCtrl = (scope, Call, timeout, filter) ->
    fetch = () ->
      scope.loading = yes
      Call.getCalls().then (calls) ->
        scope.future_calls = filter('younger')(calls, 7)
        scope.new_calls = filter('older')(calls, 7)
      .finally () ->
        scope.loading = no

    timeout ->
      fetch()
    , 60000

    fetch()

]
