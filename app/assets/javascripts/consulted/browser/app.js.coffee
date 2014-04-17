app = angular.module "consulted.browser", [
  "consulted.browser.directives"
  "ngRoute"
]

app.config [
  '$routeProvider'
  '$locationProvider'
  browserConfiguration = (routeProvider, locationProvider) ->
    locationProvider.hashPrefix "!"

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