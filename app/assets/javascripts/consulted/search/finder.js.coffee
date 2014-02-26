app = angular.module "consulted.finder", [
  'mgcrea.ngStrap.typeahead'
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
    controller: 'FinderCtrl'
    templateUrl: 'finder'
]

app.service 'GroupData', [
  '$http'
  '$q'
  (http, q) ->
    groups = http.get('/groups.json')
    getGroups: () ->
      result = q.defer()
      groups.then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise
]


app.controller "FinderCtrl", [
  '$scope'
  'GroupData'
  (scope, GroupData) ->

    scope.loading = yes
    GroupData.getGroups().then (groups) ->
      scope.$broadcast 'groups:ready', groups
    , (err) ->
      scope.error = yes
    .finally () ->
      scope.loading = no

    transform = (_, groups) ->

      getData = (group, path = "", delim = " > ") ->
        if group.children.length > 0
          path += "#{group.name}#{delim}"
          getData child, path, delim for child in group.children
        else
          path += group.name
          result =
            path: path
            id: group.id

      structures = []

      angular.forEach groups, (group) ->
        structures.push obj for obj in getData(group)

      scope.groups = structures


    scope.$on 'groups:ready', transform

]

app.directive "groupDisplay", [
  () ->
    replace: yes
    templateUrl: 'display'
    scope: no
]

