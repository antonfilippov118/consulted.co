app = angular.module 'consulted.offer_select.controllers', [
  'consulted.offer_select.services'
]


app.controller 'ScheduleCtrl', [
  '$scope'
  (scope) ->
    scope.events = []
]

app.controller 'OffersCtrl', [
  '$scope'
  'ExpertOffers'
  (scope, ExpertOffers) ->
    fetch = () ->
      scope.loading = yes
      ExpertOffers.get().then (data) ->
        scope.offers = data
      .finally () ->
        scope.loading = no

    fetch()
]

