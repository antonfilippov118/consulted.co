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
