app = angular.module "consulted.finder", [
  'siyfion.sfTypeahead'
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
    controller: 'FinderCtrl'
    templateUrl: 'finder'
]

app.controller "FinderCtrl", [
  '$scope'
  'GroupData'
  FinderCtrl = (scope, GroupData) ->

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

      results = groups.map (group) -> getData group

      merged = (groups, paths = []) ->
        if angular.isArray groups
          merged group, paths for group in groups
        else
          paths.push groups
        paths

      _groups.add path for path in merged results


    scope.$on 'groups:ready', transform

    scope.options =
      highlight: yes

    scope.search = () ->
      return if scope.searching
      return unless angular.isObject scope.selected
      return unless angular.isObject scope.selected.id
      scope.searching = yes
      GroupData.findGroup(scope.selected.id).then (group) ->
        scope.group = group
      , (err) ->
        scope.group = null
        scope.searchError = yes
      .finally () ->
        scope.searching = no

]

app.directive "groupDisplay", [
  groupDisplay = () ->
    replace: yes
    templateUrl: 'display'
    scope: no
]

