app = angular.module 'consulted.offer_select.controllers', [
  'consulted.offer_select.services'
]


app.controller 'AvailabilityCtrl', [
  '$scope'
  'ExpertAvailabilities'
  (scope, ExpertAvailabilities) ->

    fetch = (_, offer) ->
      ExpertAvailabilities.get(offer).then (events) ->
        scope.events = events
      .finally -> scope.show_cal = yes

    scope.$on 'offer:change', fetch
]

app.controller 'OffersCtrl', [
  '$scope'
  'ExpertOffers'
  OffersCtrl = (scope, ExpertOffers) ->
    selected = null

    fetch = () ->
      scope.loading = yes
      ExpertOffers.get().then (data) ->
        scope.offers = data
      .finally () ->
        scope.loading = no

    fetch()
]

