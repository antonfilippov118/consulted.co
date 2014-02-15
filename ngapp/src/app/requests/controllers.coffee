app = angular.module "consulted.requests.controllers", [
  'consulted.groups.services'
  'consulted.requests.services'
]

app.controller "SearchRequestCtrl", [
  '$scope'
  'Groups'
  'Search'
  'Saving'
  (scope, Groups, Search, Saving) ->
    scope.loading = yes
    Groups.getGroups().then (groups) ->
      scope.groups = groups
    , (err) ->
      scope.error = yes
    .finally () ->
      scope.loading = no

    scope.search = () ->
      Saving.show()
      Search.perform(scope.searchOptions).then (result) ->
        scope.result = result
      , (err) ->
        scope.searchError = err
      .finally () ->
        Saving.hide()
]
