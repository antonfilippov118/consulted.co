app = angular.module "consulted.browser.controllers", [
  'consulted.common'
  'ui.bootstrap'
  'consulted.browser.services'
]

app.controller "LookupCtrl", [
  '$scope'
  'Search'
  '$rootScope'
  '$modal'
  (scope, Search, rootScope, modal) ->
    scope.lookup = ->
      return unless scope.term
      return if scope.searching
      scope.search_active = yes
      scope.searching = yes
      rootScope.$emit 'search:enable'
      Search.do(scope.term).then (groups) ->
        scope.result = groups.length > 0
        scope.groups = groups
      , (err) ->
        scope.error = yes
      .finally () ->
        scope.searching = no

    scope.reset = () ->
      scope.term = ''
      rootScope.$emit 'search:disable'
      scope.search_active = no

    scope.learn = (group) ->
      modalInstance = modal.open
        templateUrl: 'learn'
        controller: 'WindowCtrl'
        windowClass: 'modal-learn'
        resolve:
          group: -> group.slug
]

app.controller "MainCtrl", [
  '$scope'
  '$rootScope'
  (scope, $rootScope) ->
    $rootScope.$on 'search:enable', -> scope.search_active = yes
    $rootScope.$on 'search:disable', -> scope.search_active = no
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
      scope.groups   = (group.children.splice(0, number) while group.children.length)
      scope.offering = offering
      scope.group    = group

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
  BrowseCtrl = (scope, GroupData) ->
    GroupData.getGroups()
]
