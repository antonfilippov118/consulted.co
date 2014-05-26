app = angular.module 'consulted.booking.controllers', [
  'consulted.booking.services'
  'ui.bootstrap'
]

app.controller 'BookingCtrl', [
  '$scope'
  'Offer'
  'Book'
  '$window'
  'Storage'
  '$modal'
  (scope, Offer, Book, $window, Storage, $modal) ->
    scope.request = {}

    Offer.get().then (data) ->
      scope.$broadcast 'data:ready', data

    scope.confirm = () ->
      scope.request.message ||= ''
      instance = $modal.open
        templateUrl: 'confirm'
        controller: 'ConfirmCtrl'
        resolve:
          request: -> scope.request

      instance.result.then (request) ->
        scope.sending = yes
        Book.confirm(scope.request).then (data) ->
          # successful, redirect
          $window.location.assign '/requests/success'
        , (err) ->
          scope.error = yes
          scope.message = err.data.error
        .finally () ->
          scope.sending = no

]

app.controller 'ConfirmCtrl', [
  '$scope'
  'request'
  '$modalInstance'
  (scope, request, modalInstance) ->
    scope.request = request

    scope.confirm = () ->
      modalInstance.close(scope.request)

    scope.dismiss = () ->
      modalInstance.dismiss()

]
