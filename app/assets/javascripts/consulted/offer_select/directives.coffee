app = angular.module 'consulted.offer_select.directives', [
  'consulted.offer_select.services'
]

app.directive 'dhxSchedulerReadonly', [
  'SchedulerReadonly'
  (Scheduler) ->
    restrict: 'A'
    scope:
      events: '='
    transclude: yes
    template: '<div class="dhx_cal_navline" ng-transclude></div><div class="dhx_cal_header"></div><div class="dhx_cal_data"></div>'
    link: (scope, el, attrs, ctrl) ->
      scope.$watch () ->
        "#{el[0].offsetWidth}.#{el[0].offsetHeight}"
      , () ->
        scheduler.setCurrentView()

      el.addClass 'dhx_cal_container'

      scope.$watch 'events', (collection) ->
        return unless collection
        return unless collection.length > 0
        Scheduler.addEvents collection
      , yes

      Scheduler.init(el, attrs.readonly isnt undefined)

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

app.directive 'offerLengths', [
  () ->
    replace: yes
    template: '<div ng-hide="no_offer">You can schedule a call for <strong>{{lengths}} <span ng-show="last">or {{last}}</span> minutes.</strong></div>'
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

