app = angular.module "consulted.finder", [
  'siyfion.sfTypeahead'
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
    findGroup: (id) ->
      result = q.defer()
      groups.then (response) ->
        find = (groups, id) ->
          for group in groups when group.id is id
            return group
          find group.children, id
        result.resolve find response.data, id
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

    _groups = new Bloodhound
        datumTokenizer: (d) -> Bloodhound.tokenizers.whitespace d.path
        queryTokenizer: Bloodhound.tokenizers.whitespace
        local: []

    _groups.initialize()

    scope.data =
      displayKey: 'path'
      source: _groups.ttAdapter()

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

      angular.forEach groups, (group) ->
        _groups.add obj for obj in getData(group)

    scope.$on 'groups:ready', transform

    scope.options =
      highlight: yes

    scope.search = () ->
      return unless angular.isObject scope.selected
      return unless angular.isString scope.selected.id
      scope.searching = yes
      GroupData.findGroup(scope.selected.id).then (group) ->
        scope.group = group
      , (err) ->
        scope.searchError = yes
      .finally () ->
        scope.searching = no

]

app.directive "groupDisplay", [
  () ->
    replace: yes
    templateUrl: 'display'
    scope: no
]

