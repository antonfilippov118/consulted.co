app = angular.module "consulted", [
  'templates-app'
  'ngRoute'
  "consulted.directives"
  "consulted.controllers"
]

app.config [
  "$locationProvider",
  "$routeProvider",
  (locationProvider, routeProvider) ->
    locationProvider.hashPrefix "!"

    routeProvider
      .when "/",
        template: "<div consulted-startpage></div>"
      .when "/signup",
        controller: "SignupController"
        templateUrl: "views/signup.tpl.html"
      .otherwise redirectTo: "/"
]
