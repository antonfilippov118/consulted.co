app = angular.module "consulted.requests", [
  'consulted.requests.controllers'
]

app.config [
  '$routeProvider'
  (routeProvider) ->
    routeProvider.when '/request_a_call',
      controller: "RequestCtrl"
      templateUrl: "views/requests/request.tpl.html"

]