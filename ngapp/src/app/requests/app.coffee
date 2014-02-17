app = angular.module "consulted.requests", [
  'consulted.requests.controllers'
  'consulted.requests.directives'
]

app.config [
  '$routeProvider'
  (routeProvider) ->
    routeProvider.when '/request_a_call',
      controller: "SearchRequestCtrl"
      templateUrl: "views/requests/request.tpl.html"

]