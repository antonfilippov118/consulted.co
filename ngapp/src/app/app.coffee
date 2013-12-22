app = angular.module "consulted", [
  'templates-app',
  'ngRoute',
  "consulted.directives"
]

app.config [
  "$locationProvider",
  "$routeProvider",
  (locationProvider, routeProvider) ->
    locationProvider.hashPrefix "!"

    routeProvider
      .when "/",
        template: "<div consulted-startpage></div>"
      .otherwise redirectTo: "/"
]
