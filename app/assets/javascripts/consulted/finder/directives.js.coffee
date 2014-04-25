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
    scope: yes
    replace: no
    link: (scope) ->
      scope.languages = Language.getLanguages()
      scope.isActive  = Language.isActive
      scope.toggle    = Language.toggle
]
app.directive 'continents', [
  'Continent'
  (Continent) ->
    scope: yes
    replace: no
    link: (scope) ->
      scope.continents = Continent.getContinents()
      scope.isActive   = Continent.isActive
      scope.toggle     = Continent.toggle

]

app.directive 'bookmark', [
  'Bookmark'
  (Bookmark) ->
    replace: no
    scope: yes
    link: (scope) ->
      scope.isActive = Bookmark.isActive
      scope.toggle   = Bookmark.toggle

]

app.directive 'tags', [
  'Tag'
  (Tag) ->
    scope: yes
    replace: no
    link: (scope) ->
      scope.tags   = Tag.getTags()
      scope.remove = Tag.remove
      scope.add    = () ->
        if scope.adding isnt yes
          return scope.adding = yes
        Tag.add scope.next_tag
        scope.next_tag = ""
        scope.adding = no


]