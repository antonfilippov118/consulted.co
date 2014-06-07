app = angular.module 'consulted.offer_select.directives', [
  'consulted.offer_select.services'
]

app.directive 'offer', [
  'ExpertOffers'
  (ExpertOffers) ->
    replace: yes
    templateUrl: 'offer'
    scope:
      offer: '='
    link: (scope) ->
      scope.select = ExpertOffers.select
      scope.selected = ExpertOffers.selected

]

app.directive 'offerInfo', [
  () ->
    replace: yes
    templateUrl: 'info'
    scope: yes
    link: (scope) ->
      scope.no_offer = yes
      scope.$on 'offer:change', (_, offer) ->
        lengths = offer.lengths.map((string) -> +string).sort (a, b) -> a - b
        if lengths.length > 1
          scope.lengths = lengths.slice(0, -1).join ', '
          scope.last    = lengths[lengths.length - 1]
        else
          scope.lengths = lengths[0]
          scope.last = no
        scope.no_offer = no

]

