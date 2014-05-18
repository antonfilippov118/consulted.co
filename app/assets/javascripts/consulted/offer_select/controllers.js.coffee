app = angular.module 'consulted.offer_select.controllers', [
  'consulted.offer_select.services'
]


app.controller 'AvailabilityCtrl', [
  '$scope'
  'ExpertAvailabilities'
  (scope, ExpertAvailabilities) ->
    ExpertAvailabilities.get().then (events) ->
      scope.events = events
]

app.controller 'OffersCtrl', [
  '$scope'
  'ExpertOffers'
  (scope, ExpertOffers) ->
    selected = null

    fetch = () ->
      scope.loading = yes
      ExpertOffers.get().then (data) ->
        scope.offers = data
      .finally () ->
        scope.loading = no

    fetch()
]

