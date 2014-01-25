app = angular.module "consulted.users", [
  "consulted.users.controllers"
  "consulted.users.directives"
  'ngRoute'
]

app.config [
  "$httpProvider"
  "$routeProvider"
  (httpProvider, routeProvider) ->
    # use an interceptor to redirect to the login page
    interceptor = [
      '$location'
      '$rootScope'
      '$q'
      (location, rootScope, q) ->
        success = (response) ->
          response

        error = (response) ->
          if response.status is 401
            rootScope.$broadcast 'event:unauthorized'
            location.path "/login"
            return response
          q.reject response

        (promise) ->
          promise.then success, error
    ]

    httpProvider.responseInterceptors.push interceptor

    routeProvider
      .when "/signup",
        controller: "SignupController"
        templateUrl: "views/users/signup.tpl.html"
      .when "/login",
        controller: "LoginController"
        templateUrl: "views/users/login.tpl.html"


]
