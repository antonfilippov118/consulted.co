app = angular.module 'consulted.requests.directives', [
  'consulted.offers.directives'
  'consulted.requests.calendar'
]

app.directive 'searchGroupSelect', [
  () ->
    replace: yes
    templateUrl: 'views/requests/select_groups.tpl.html'
    scope:
      groups: "="
]

app.directive "searchSubgroup", [
  'TemplateRecursion'
  (TemplateRecursion) ->
    replace: yes
    templateUrl: 'views/requests/subgroup.tpl.html'
    restrict: "A"
    scope:
      group: "="
    compile: (element) ->
      TemplateRecursion.compile element
]

app.directive "searchSteps", [
  () ->
    replace: yes
    templateUrl: "views/requests/steps.tpl.html"
    scope: no
]

app.directive "searchTiming", [
  () ->
    replace: yes
    templateUrl: 'views/requests/timing.tpl.html'
    scope: yes
    link: (scope) ->
      scope.timings = [
        30
        45
        60
        90
        120
      ]

      scope.select = (event, index) ->
        scope.selected = index
]

app.direct

app.directive "searchLanguages", [
  () ->
    replace: yes
    templateUrl: 'views/requests/languages.tpl.html'
    scope: yes
    link: (scope) ->
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
]
