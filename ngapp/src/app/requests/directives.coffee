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
    controller: [
      '$scope'
      (scope) ->
        enabled = no
        scope.toggle = ->
          enabled = !enabled
          scope.enabled = enabled
          scope.$emit 'groups:update', scope.group._id.$oid
    ]
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
    controller: 'TimeCtrl'
]

app.direct

app.directive "searchLanguages", [
  () ->
    replace: yes
    templateUrl: 'views/requests/languages.tpl.html'
    scope: yes
    controller: 'LanguageCtrl'
]
