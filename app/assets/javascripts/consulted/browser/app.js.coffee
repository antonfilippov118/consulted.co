app = angular.module "consulted.browser", [
  "consulted.browser.directives"
  "ngRoute"
  'siyfion.sfTypeahead'
]

app.config [
  '$routeProvider'
  '$locationProvider'
  browserConfiguration = (routeProvider, locationProvider) ->
    routeProvider
      .when "/",
        controller: "BrowseCtrl"
        templateUrl: "browse"
      .when "/:slug",
        controller: 'GroupCtrl'
        templateUrl: 'group'
      .otherwise
        redirectTo: '/'

]
