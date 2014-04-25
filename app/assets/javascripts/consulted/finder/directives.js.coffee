app = angular.module 'consulted.finder.directives', [
  'consulted.finder.controllers'
  'consulted.finder.services'
]

app.directive 'filter', [
  () ->
    replace: yes
    templateUrl: 'filter'
    controller: 'FilterCtrl'
    scope: yes
]

app.directive 'languages', [
  'Language'
  (Language) ->
    scope: no
    replace: no
    link: (scope) ->
      scope.languages = Language.getLanguages()
      scope.isActive  = Language.isActive
      scope.toggle    = Language.toggle
]

app.directive 'tags', [
  'Tags'
  (Tags) ->
    sope: no
    replace: no
    link: (scope) ->
      scope.tags   = Tags.getTags()
      scope.remove = Tags.remove
      scope.add    = () ->
        if scope.adding isnt yes
          return scope.adding = yes
        Tags.add scope.next_tag
        scope.next_tag = ""
        scope.adding = no


]