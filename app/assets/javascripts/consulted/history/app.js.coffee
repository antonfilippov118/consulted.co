app = angular.module 'consulted.history', [
  'consulted.common'
  'ngRoute'
  'consulted.history.controllers'
  'consulted.history.directives'
]

app.config [
  '$routeProvider'
  (routeProvider) ->
    routeProvider.when '/',
      redirectTo: '/requested'
    .when '/offered',
      templateUrl: 'calls'
      controller: 'CallsCtrl'
    .when '/requested',
      templateUrl: 'calls'
      controller: 'CallsCtrl'
    .otherwise
      redirectTo: '/'
]

