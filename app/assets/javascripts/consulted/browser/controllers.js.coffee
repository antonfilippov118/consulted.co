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
  '$location'
  (scope, GroupData, routeParams, modal, location) ->
    scope.loading = yes
    GroupData.findGroup(routeParams.slug).then (group) ->
      if group is undefined
        return location.path '/'
      scope.$emit 'group:ready', group
    , (err) ->
      scope.error = yes
    .finally ->
      scope.loading = no

    scope.$on 'group:ready', (_, group) ->
      scope.group = group
      scope.lastCategory = GroupData.isLastCategory group

    scope.$on 'group:ready', (_, group) ->
      GroupData.findBreadCrumb(group.slug).then (crumbs) ->
        scope.crumbs = crumbs
        scope.slugs  = crumbs.map (group) -> group.slug

    scope.$on 'group:ready', (_, group) ->
      GroupData.findParent(group).then (parent) ->
        if group.children.length is 0
          return location.path "#{parent.slug}"
        scope.parent = parent

    scope.inPath = (slug) ->
      return no unless angular.isArray scope.slugs
      slug in scope.slugs

    scope.select = (group) ->
      location.path "#{group.slug}"

    scope.last = (level) ->
      return no unless level
      level.depth > 0

    scope.getActiveGroup = () ->
      return scope.parent if GroupData.isLastCategory scope.group
      scope.group

    scope.getSubGroup = () ->
      return scope.group.children if GroupData.isLastCategory scope.group
      []

    scope.same = (level) ->
      return no unless scope.parent and scope.group
      level.slug is scope.parent.slug or level.slug is scope.group.slug

    scope.learn = (group) ->
      modalInstance = modal.open
        templateUrl: 'learn'
        controller: 'WindowCtrl'
        windowClass: 'modal-learn'
        resolve:
          group: -> group.slug
]

app.controller 'ChildCtrl', [
  '$scope'
  (scope) ->

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
