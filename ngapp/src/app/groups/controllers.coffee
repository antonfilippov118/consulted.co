app = angular.module "consulted.groups.controllers", [
  'consulted.groups.services'
]

app.controller "GroupsController", [
  "$scope"
  "Groups"
  "$timeout"
  (scope, Groups, timeout) ->

    scope.loading = yes
    scope.error   = no

    Groups.getGroups().then (groups) ->
      scope.groups = groups
    , (err) ->
      scope.error = "There was an error loading the data."
    .finally () ->
      scope.loading = no
]
