app = angular.module "consulted.navigation.controllers", [
  'consulted.users.services'
]

app.controller 'NavigationController', [
  '$scope'
  'User'
  (scope, user) ->
    scope.logout = user.logout
    scope.$on 'event:authchange', ->
      scope.loggedIn = user.isLoggedIn()
    scope.$on 'event:unauthorized', () ->
      scope.loggedIn = no
]
