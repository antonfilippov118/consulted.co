app = angular.module "consulted.browser.directives", [
  "consulted.browser.controllers"
]

app.directive "lookup", [
  () ->
    replace: yes
    scope: yes
    templateUrl: "lookup"
    controller: 'LookupCtrl'
]

app.directive "browse", [
  () ->
    replace: yes
    scope: yes
    templateUrl: "browse"
    controller: 'BrowseCtrl'
]

app.directive 'child', [
  () ->
    replace: yes
    scope:
      child: "="
    templateUrl: 'child'
    controller: 'ChildCtrl'
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
