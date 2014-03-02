app = angular.module 'consulted.categories', [
  'consulted.common'
]

app.run [
  '$rootElement'
  ($rootElement) ->
    newEl = $('<div component></div>')
    $rootElement.append newEl
]

app.directive 'component', [
  () ->
    replace: yes
    controller: 'CategoriesCtrl'
    templateUrl: 'categories'
]

app.controller 'CategoriesCtrl', [
  '$scope'
  'GroupData'
  CategoriesCtrl = (scope, GroupData) ->
    GroupData.getGroups().then (groups) ->
      scope.groups = groups


]
