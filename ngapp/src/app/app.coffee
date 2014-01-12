app = angular.module "consulted", [
  'templates-app'
  'ngRoute'
  "consulted.directives"
  "consulted.controllers"
]

app.config [
  "$locationProvider"
  "$routeProvider"
  "$httpProvider"
  (locationProvider, routeProvider, httpProvider) ->

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
      .when "/profile",
        controller: "ProfileController"
        templateUrl: "views/profile.tpl.html"
      .otherwise redirectTo: "/"

    static_content = [
      "categories"
      "experts"
      "use_cases"
      "faq"
      "career"
      "sitemap"
      "legal"
    ]

    for page in static_content
      camelize = (string) ->
        string.replace /\_([a-z])/g, (g) -> g[1].toUpperCase()

      name = "#{page[0].toUpperCase()}#{page.substr(1)}"
      routeProvider.when "/#{page}",
        templateUrl: "views/#{page}.tpl.html"
        controller: "#{camelize name}Controller"

]
