app = angular.module 'consulted.offers_tree', [
  'consulted.common'
  'ui.bootstrap'
]

app.controller 'GroupsCtrl', [
  '$scope'
  'GroupData'
  (scope, GroupData) ->
    fetch = () ->
      scope.loading =  yes
      GroupData.getGroups().then (groups) ->
       scope.$broadcast 'data:ready', groups
      .finally () ->
        scope.loading = no

    fetch()

]

app.directive 'groups', [
  () ->
    replace: yes
    templateUrl: 'groups'
    link: (scope) ->
      scope.$on 'data:ready', (_, groups) ->
        scope.groups = groups

]

app.directive 'group', [
  () ->
    replace: yes
    templateUrl: 'group'
    scope:
      group: '='
]

app.directive 'child', [
  'RecursionHelper'
  '$modal'
  childDirective = (RecursionHelper, modal) ->
    replace: yes
    templateUrl: 'child'
    scope:
      child: '='
    compile: (el) -> RecursionHelper.compile el, (scope, el) ->
      scope.learn = (child) ->
        modal.open
          resolve:
            group: () -> child
          controller: 'WindowCtrl'
          templateUrl: 'learn'

]

app.controller 'WindowCtrl', [
  '$scope'
  '$modalInstance'
  'group'
  (scope, modalInstance, group) ->
    scope.group = group
    scope.close = () ->
      modalInstance.dismiss()
]

app.factory "RecursionHelper", [
  "$compile"
  ($compile) ->

    ###
    Manually compiles the element, fixing the recursion loop.
    @param element
    @param [link] A post-link function, or an object with function(s) registered via pre and post properties.
    @returns An object containing the linking functions.
    ###
    return compile: (element, link) ->

      # Normalize the link parameter
      link = post: link  if angular.isFunction(link)

      # Break the recursion loop by removing the contents
      contents = element.contents().remove()
      compiledContents = undefined
      pre: (if (link and link.pre) then link.pre else null)

      ###
      Compiles and re-adds the contents
      ###
      post: (scope, element) ->

        # Compile the contents
        compiledContents = $compile(contents)  unless compiledContents

        # Re-add the compiled contents to the element
        compiledContents scope, (clone) ->
          element.append clone
          return

        # Call the post-linking function, if any
        link.post.apply null, arguments if link and link.post
        return
]
