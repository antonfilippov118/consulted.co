app = angular.module "consulted.offers.controllers", [
  'consulted.users.services'
  'consulted.groups.services'
]

app.controller "OfferController", [
  '$scope'
  'User'
  'Groups'
  (scope, User, Groups) ->

    User.getProfile().then (user) ->
      scope.user = user
    Groups.getGroups().then (groups) ->
      scope.groups = groups

]
