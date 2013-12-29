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
      .when "/login",
        controller: "LoginController"
        templateUrl: "views/login.tpl.html"
      .when "/contact",
        controller: "ContactController"
        templateUrl: "views/contact.tpl.html"
      .otherwise redirectTo: "/"
]
