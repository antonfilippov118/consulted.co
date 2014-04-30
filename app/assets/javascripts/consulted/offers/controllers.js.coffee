app = angular.module 'consulted.offers.controllers', [
  'consulted.common'
  'ui.bootstrap'
]

app.controller 'CategoriesCtrl', [
  '$scope'
  'GroupData'
  'OfferData'
  '$modal'
  (scope, GroupData, OfferData, modal) ->
    path = []
    scope.loading =  yes
    GroupData.getRoots().then (roots) ->
      scope.roots = roots
    , (err) ->
      scope.error = yes
    .finally () ->
      scope.loading = no

    OfferData.getOffers().then (offers) ->
      scope.offers = offers

    scope.use = (group) ->
      GroupData.findBreadCrumb(group.slug).then (crumbs) ->
        path = crumbs

    scope.inPath = (group) ->
      return no if group is undefined
      group.slug in (path.map (group) -> group.slug)

    scope.selectedRoot     = () -> path[0]
    scope.selectedGroup    = () -> path[1]
    scope.selectedCategory = () -> path[2]
]

app.controller 'OfferCtrl', [
  '$scope'
  'OfferData'
  (scope, OfferData) ->

    scope.select = (offer) ->
      offer.enabled = yes
      scope.selecting = yes
      OfferData.save(offer).finally () ->
        scope.selecting = no

]

app.controller 'EditorCtrl', [
  '$scope'
  'OfferData'
  '$modal'
  (scope, OfferData, modal) ->

    fetch = () ->
      OfferData.getOffers().then (offers) ->
        scope.offers = offers

    scope.times = ["30", "45", "60", "90", "120"]
    scope.selected = (time, offer) -> time in offer.lengths

    trigger = (offer) ->
      OfferData.delayedSave(offer)

    scope.toggleTime = (time, offer) ->
      idx = offer.lengths.indexOf time
      if idx > -1
        offer.lengths.splice idx, 1
      else
        offer.lengths.push time
      trigger offer

    scope.remove = (offer) ->
      offer.enabled = no
      OfferData.save offer

    scope.save = (offer) ->
      trigger offer

    scope.learn = (group) ->
      modalInstance = modal.open
        templateUrl: 'learn'
        controller: 'WindowCtrl'
        windowClass: 'modal-learn'
        resolve:
          group: -> group.slug

    scope.$on 'offers:update', fetch
    fetch()

]