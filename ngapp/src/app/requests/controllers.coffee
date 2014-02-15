app = angular.module "consulted.requests.controllers", [
  'consulted.groups.services'
]

app.controller "RequestCtrl", [
  '$scope'
  (scope) ->
    scope.foo = "bar"
]