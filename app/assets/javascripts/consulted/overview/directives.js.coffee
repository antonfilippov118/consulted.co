app = angular.module 'consulted.overview.directives', []

app.directive 'call', [
  () ->
    replace: yes
    templateUrl: 'call'
    scope:
      call: "="
]

app.directive 'noCalls', [
  () ->
    replace: yes
    templateUrl: 'no_call'
    scope:
      text: '@'
]
