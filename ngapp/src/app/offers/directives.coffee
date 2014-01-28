app = angular.module 'consulted.offers.directives', []

app.directive "subgroup", [
  'TemplateRecursion'
  (Template) ->
    replace: yes
    templateUrl: 'views/offers/subgroup.tpl.html'
    restrict: "A"
    scope:
      group: "="
    controller: ['$scope', (scope) ->
      scope.toggle = (e) ->

    ]
    compile: (element) ->
      Template.compile element

]

app.service "TemplateRecursion", [
  '$compile'
  ($compile) ->
    compile: (element) ->
      contents = element.contents().remove()
      compiledContents = null
      (scope, element) ->

        if !compiledContents
          compiledContents = $compile(contents)
        compiledContents scope, (clone) ->
          element.append clone
]