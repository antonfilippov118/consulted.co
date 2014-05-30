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

    scope.$on 'data:ready', (_, data) -> scope.offer = data

    optimize = () ->
      return unless angular.isObject window.optimizely
      return unless scope.offer
      valueInCents = (scope.request.length / 60) * scope.offer.rate * 100
      data =  [
        'trackEvent'
        'callRevenue'
        revenue: valueInCents
      ]
      window.optimizely.push data
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
          optimize(scope.request)
          $window.location.href = '/requests/success'
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
