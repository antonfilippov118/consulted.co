app = angular.module "consulted.navigation.directives", [
  'consulted.navigation.controllers'
]

app.directive "navigation", [
  () ->
    replace: yes
    scope: yes
    templateUrl: 'views/navigation/navigation.tpl.html'
    controller: 'NavigationController'
]