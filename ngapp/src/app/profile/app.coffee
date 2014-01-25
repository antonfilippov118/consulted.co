app = angular.module "consulted.profile", [
  'consulted.profile.controllers'
]

app.config [
  '$routeProvider'
  (routeProvider) ->
    routeProvider
      .when "/profile",
        controller: "ProfileController"
        templateUrl: "views/profile/profile.tpl.html"
      .when "/profile/settings",
        controller: "SettingsController"
        templateUrl: "views/profile/settings.tpl.html"
]
