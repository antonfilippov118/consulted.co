app = angular.module 'consulted.booking.controllers', [
  'consulted.booking.services'
]

app.controller 'BookingCtrl', [
  '$scope'
  'Offer'
  'Book'
  '$window'
  'Storage'
  (scope, Offer, Book, $window, Storage) ->
    scope.request = {}

    Offer.get().then (data) ->
      scope.$broadcast 'data:ready', data

    scope.confirm = () ->
      scope.request.message ||= ''
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
