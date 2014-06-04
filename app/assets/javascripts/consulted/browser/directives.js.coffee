app = angular.module "consulted.browser.directives", [
  "consulted.browser.controllers"
  "consulted.common"
]

app.directive "lookup", [
  () ->
    replace: yes
    scope: yes
    templateUrl: "lookup"
    controller: 'LookupCtrl'
]

app.directive 'categoryBar', [
  () ->
    replace: yes
    scope: no
    templateUrl: 'categories'
    link: (scope) ->
      scope.currentSibling = (group) ->
        group is scope.group
]

app.directive 'popular', [
  '$location'
  (location) ->
    replace: yes
    scope: yes
    templateUrl: 'popular'
    link: (scope) ->
      scope.selected = () ->
        location.path() isnt '/'

      scope.$on 'search:enable', () ->
        scope.hide = yes

      scope.$on 'search:disable', () ->
        scope.hide = no

]

app.directive 'bread', [
  '$location'
  'GroupData'
  (location, GroupData) ->
    replace: yes
    scope:
      group: "="
    templateUrl: 'bread'
    link: (scope, el, attrs) ->
      scope.hideGroup = attrs['hideGroup'] isnt undefined
      scope.hideRoot  = attrs['hideRoot'] isnt undefined

      scope.$watch 'group', (group) ->
        return if group is undefined
        GroupData.findBreadCrumb(group.slug).then (crumbs) ->
          crumbs.splice(crumbs.length - 1, 1) if scope.hideGroup
          scope.crumbs = crumbs
        , (err) ->
          scope.error = yes

]

app.directive 'child', [
  () ->
    replace: yes
    scope:
      child: '='
    templateUrl: 'child'
    link: (scope) ->
      open = no
      scope.open = -> open
      scope.toggle = -> open = !open
]

app.directive 'noResults', [
  'Contact'
  noResultsDirective = (Contact) ->
    replace: yes
    scope:
      groups: '='
      term: "="
    templateUrl: 'no_results'
    link: (scope) ->
      scope.$watch 'groups', (groups) ->
        scope.show = groups?.length is 0
        scope.sent = no

      scope.request = () ->
        scope.sending = yes
        Contact.requestServiceOffering(scope.term).then (bool) ->
          scope.sent = bool
        , (bool) ->
          scope.sent = bool
        .finally ->
          scope.sending = no
]
