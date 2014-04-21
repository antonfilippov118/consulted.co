app = angular.module "consulted.browser", [
  "consulted.browser.directives"
  "ngRoute"
]

app.config [
  '$routeProvider'
  '$locationProvider'
  browserConfiguration = (routeProvider, locationProvider) ->
    routeProvider
      .when "/",
        controller: "MainCtrl"
        templateUrl: "main"
      .when "/:slug",
        controller: 'GroupCtrl'
        templateUrl: 'group'
      .otherwise
        redirectTo: '/'

]