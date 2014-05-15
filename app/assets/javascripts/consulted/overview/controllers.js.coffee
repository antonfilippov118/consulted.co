app = angular.module 'consulted.overview.controllers', [
  'consulted.overview.services'
  'consulted.overview.filters'
  'consulted.finder.filters'
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
        scope.new_calls    = filter('younger')(calls, 7)
        scope.future_calls = filter('older')(calls, 7)
      .finally () ->
        scope.loading = no

    timeout ->
      fetch()
    , 30000

    scope.$on 'reload:calls', fetch

    fetch()
]

app.controller 'CancelCtrl', [
  'Call'
  'call'
  '$scope'
  '$modalInstance'
  CancelCtrl = (Call, call, scope, modalInstance) ->
    scope.call = call

    scope.verb = ->
      return 'Cancel' if call.active
      return 'Abandon' if call.seeker
      return 'Deny' if call.expert
      'Cancel'

    scope.dismiss = () ->
      modalInstance.dismiss()

    scope.cancel = () ->
      Call.cancel(call).then (result) ->
        modalInstance.close()
      , (err) ->
        CONSULTED.trigger err, type: 'error', timeout: 3000
]

app.controller 'ConfirmCtrl', [
  'Call'
  'call'
  '$scope'
  '$modalInstance'
  ConfirmCtrl = (Call, call, scope, modalInstance) ->
    scope.call = call
    scope.dismiss = () ->
      modalInstance.dismiss()
    scope.confirm = ->
      Call.confirm(call).then (result) ->
        modalInstance.close()
      , (err) ->
        CONSULTED.trigger err, type: 'error', timeout: 3000

]
