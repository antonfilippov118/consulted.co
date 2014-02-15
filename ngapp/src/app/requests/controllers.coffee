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

    options =
      times: []
      languages: []
      groups: []

    scope.$on "calendar:update", (_, data) ->
      options['times'] = data

    scope.$on "lengths:update", (_, data) ->
      options['length'] = data

    scope.$on 'languages:update', (_, data) ->
      options['languages'] = data

    scope.$on 'groups:update', (_, data) ->
      {groups} = options
      idx = groups.indexOf data
      if idx > -1
        groups.splice idx, 1
      else
        groups.push data
      options['groups'] = groups

    scope.canSearch = () ->
      console.log options
      return no unless options.times.length > 0
      return no unless options.length > 0
      return no unless options.languages.length > 0
      return no unless options.groups.length > 0
      yes

    scope.search = () ->
      Saving.show()
      Search.perform(options).then (result) ->
        scope.result = result
      , (err) ->
        scope.searchError = err
      .finally () ->
        Saving.hide()
]

app.controller 'TimeCtrl', [
  '$scope'
  (scope) ->
    scope.timings = [
      30
      45
      60
      90
      120
    ]

    scope.select = (event, index) ->
      scope.selected = index
      scope.$emit 'lengths:update', scope.timings[index]
]

app.controller 'LanguageCtrl', [
  '$scope'
  (scope) ->
    scope.languages = [
      'english'
      'mandarin'
      'spanish'
      'german'
      'arabic'
    ]

    selected = []

    scope.isSelected = (index) ->
      index in selected

    scope.select = (event, index) ->
      idx = selected.indexOf index
      if idx > -1
        selected.splice idx, 1
      else
        selected.push index

      langs = []
      for lang, idx in scope.languages when idx in selected
        langs.push lang

      scope.$emit "languages:update", langs


]
