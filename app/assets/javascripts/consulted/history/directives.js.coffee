app =  angular.module 'consulted.history.directives', []

app.directive 'tabs', [
  () ->
    replace: yes
    scope: yes
    controller: 'TabsCtrl'
    templateUrl: 'tabs'
]
