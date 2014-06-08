app = angular.module 'consulted.offers_tree', [
  'consulted.common'
]

app.controller 'GroupsCtrl', [
  '$scope'
  'GroupData'
  (scope, GroupData) ->
    fetch = () ->
      scope.loading =  yes
      GroupData.getGroups().then (groups) ->
       scope.$broadcast 'data:ready', groups
      .finally () ->
        scope.loading = no

    fetch()

]

app.directive 'groups', [
  () ->
    replace: yes
    templateUrl: 'groups'
    link: (scope) ->
      scope.$on 'data:ready', (_, groups) ->
        scope.groups = groups

]

app.directive 'group', [
  () ->
    replace: yes
    templateUrl: 'group'
    scope:
      group: '='
]
