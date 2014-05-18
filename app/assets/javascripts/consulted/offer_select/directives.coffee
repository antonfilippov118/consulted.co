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

