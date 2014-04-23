app = angular.module 'consulted.finder.directives', [
  'consulted.finder.controllers'
]

app.directive 'filter', [
  () ->
    replace: yes
    templateUrl: 'filter'
    controller: 'FilterCtrl'
    scope: yes
]