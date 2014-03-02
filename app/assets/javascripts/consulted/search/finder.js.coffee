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
  GroupData = (http, q) ->
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
        {data} = response
        find = (data, id) ->
          for group in data
            if group.id is id
              return group
            found = find group.children, id
            return found if found

        group = find data, id
        result.resolve find data, id

      result.promise
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
      return unless angular.isString scope.selected.id
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

