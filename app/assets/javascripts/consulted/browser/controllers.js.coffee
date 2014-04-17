app = angular.module "consulted.browser.controllers", [
  'consulted.common'
  'ui.bootstrap'
]

app.controller "LookupCtrl", [
  '$scope'
  (scope) ->
    scope.lookup = ->
      console.log 'searching'
]

app.controller "MainCtrl", [
  '$scope'
  (scope) ->
]

app.controller "GroupCtrl", [
  '$scope'
  'GroupData'
  '$routeParams'
  '$modal'
  (scope, GroupData, routeParams, modal) ->
    scope.loading = yes
    GroupData.findGroup(routeParams.slug).then (group) ->
      scope.$emit 'group:ready', group
    , (err) ->
      scope.error = yes
    .finally ->
      scope.loading = no

    scope.$on 'group:ready', (_, group) ->
      offering = GroupData.isSubCategory(group)
      if offering
        number = 2
      else
        number = 3
      scope.groups = (group.children.splice(0, number) while group.children.length)
      scope.offering = offering

    scope.learn = (group) ->
      modalInstance = modal.open
        templateUrl: 'learn'
        controller: 'WindowCtrl'
        windowClass: 'modal-learn'
        resolve:
          group: -> group.slug
]

app.controller "WindowCtrl", [
  '$scope'
  '$modalInstance'
  'GroupData'
  '$timeout'
  'group'
  LearnWindowCtrl = (scope, modalInstance, GroupData, $timeout, group) ->
    $timeout ->
      $('.modal-dialog').addClass 'modal-lg'
    , 50
    scope.loading = yes
    GroupData.showGroup(group).then (groupData) ->
      scope.group = groupData
    , (err) ->
      scope.error = yes
    .finally () ->
      scope.loading = no
]

app.controller "BrowseCtrl", [
  '$scope'
  'GroupData'
  (scope, GroupData) ->
    GroupData.getGroups().then (groups) ->
      scope.roots = (groups.splice(0, 4) while groups.length)
]

app.controller 'BreadCtrl', [
  '$scope'
  '$location'
  '$routeParams'
  'GroupData'
  (scope, location, routeParams, GroupData) ->
    scope.breadcrumbsActive = () ->
      switch location.path()
        when '/' then no
        else yes

    GroupData.findBreadCrumb(routeParams.slug).then (crumbs) ->
      scope.crumbs = crumbs
    , (err) ->
      scope.error = yes

]
