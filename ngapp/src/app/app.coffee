app = angular.module "consulted", [
  "consulted.groups"
  "consulted.users"
  "consulted.offers"
  "consulted.navigation"
  "consulted.static"
  "consulted.profile"
  "consulted.common"
  'templates-app'
]

app.config [
  "$locationProvider"
  "$routeProvider"
  (locationProvider, routeProvider)->
    locationProvider.hashPrefix "!"

    routeProvider
      .when "/",
        template: "<div startpage></div>"
      .otherwise redirectTo: "/"

]
