app = angular.module "consulted.scheduler", [
  'ui.bootstrap'
  'consulted.common'
]

app.run [
  '$rootElement'
  ($rootElement) ->
    newEl = $('<div component></div>')
    $rootElement.append newEl
]

app.directive 'component', [
  () ->
    replace: yes
    controller: 'SchedulerCtrl'
    templateUrl: 'scheduler'
]

app.controller "SchedulerCtrl", [
  '$scope'
  (scope) ->



]