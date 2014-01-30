app = angular.module 'consulted.offers.directives', []

app.directive "subgroup", [
  'TemplateRecursion'
  (Template) ->
    replace: yes
    templateUrl: 'views/offers/subgroup.tpl.html'
    restrict: "A"
    scope:
      group: "="
    controller: [
      '$scope'
      '$rootScope'
      'Offers'
      (scope, rootScope, Offers) ->
        offers = []
        Offers.getOffers().then (_offers) ->
          offers = _offers.map (offer) ->
            offer._group_id if offer.enabled

        scope.enabled = (group) ->
          group._id.$oid in offers

        scope.toggle = (e) ->
          {group} = scope
          idx = offers.indexOf(group._id.$oid)
          if idx > -1
            offers.splice idx, 1
          else
            offers.push group._id.$oid

          rootScope.$broadcast "offers:group:toggle", group
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