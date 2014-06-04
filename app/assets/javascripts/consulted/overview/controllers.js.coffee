app = angular.module 'consulted.overview.controllers', [
  'consulted.overview.services'
  'consulted.overview.filters'
  'consulted.finder.filters'
]

app.controller 'TableCtrl', [
  '$scope'
  'Call'
  '$interval'
  '$filter'
  TableCtrl = (scope, Call, interval, filter) ->
    scope.loading = yes
    fetch = () ->
      Call.getCalls().then (calls) ->
        scope.new_calls    = filter('younger')(calls, 7)
        scope.future_calls = filter('older')(calls, 7)
      .finally () ->
        scope.loading = no

    interval fetch, 30000

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
      return 'Decline' if call.expert
      'Cancel'

    scope.dismiss = () ->
      modalInstance.dismiss()

    scope.cancel = () ->
      Call.cancel(call).then (result) ->
        CONSULTED.trigger 'Call cancelled'
        modalInstance.close()
      , (err) ->
        CONSULTED.trigger err, type: 'error'
]

app.controller 'ConfirmCtrl', [
  'Call'
  'call'
  '$scope'
  '$modalInstance'
  ConfirmCtrl = (Call, call, scope, modalInstance) ->
    scope.call = call
    scope.decline = () ->
      Call.cancel(call).then (result) ->
        CONSULTED.trigger 'Call declined'
        modalInstance.close()
      , (err) ->
        modalInstance.dismiss()

    scope.dismiss = ->
      modalInstance.dismiss()

    scope.confirm = ->
      Call.confirm(call).then (result) ->
        CONSULTED.trigger 'Call confirmed'
        modalInstance.close()
      , (err) ->
        CONSULTED.trigger err, type: 'error'


]
