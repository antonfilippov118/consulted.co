app = angular.module 'consulted.offers', [
  'ui.bootstrap'
  'consulted.common'
]

app.run [
  '$rootElement'
  ($rootElement) ->
    newEl = $('<div component></div>')
    $rootElement.append newEl
]

app.directive 'component', [
  () ->
    replace: yes
    controller: 'SetupCtrl'
    templateUrl: 'setup'
]

app.controller 'SetupCtrl', [
  '$scope'
  '$modal'
  "$timeout"
  'OfferData'
  (scope, $modal, $timeout, OfferData) ->
    scope.loading = yes
    OfferData.getOffers().then (offers) ->
      scope.offers = offers
    , (err) ->
      scope.error = yes
    .finally () ->
      scope.loading = no

    process = (group) ->
      save({group: { id: group.id.$oid }, enabled: yes }, no)

    save = (offer = {}, throttled = yes) ->
      if offer.group_id
        offer.group = { id: offer.group_id.$oid }

      if throttled
        return throttledSave(offer)

      _save offer

    timer = null
    throttledSave = (offer) ->
      $timeout.cancel timer if timer?
      timer = $timeout () ->
        _save(offer)
      , 1500

    _save = (offer) ->
      scope.saving = yes
      OfferData.save(offer).then (offers) ->
        scope.offers = offers
      .finally () ->
        scope.saved = yes
        scope.saving = no
        $timeout () ->
          scope.saved = no
        , 2000

    deleteOffer = (offer) ->
      offer.enabled = no
      save(offer)

    scope.save = save
    scope.delete = deleteOffer
    scope.open = () ->
      modalInstance = $modal.open
        templateUrl: 'modalWindow'
        controller: 'WindowCtrl'
        resolve:
          group: () -> scope.selectedGroup

      modalInstance.result.then process
    scope.valid = (offer) ->
      offer.description && offer.experience && offer.rate && offer.lengths


]

app.controller 'WindowCtrl', [
  '$scope'
  '$modalInstance'
  'GroupData'
  (scope, $modalInstance, GroupData) ->
    scope.loading = yes
    GroupData.getGroups().then (groups) ->
      scope.groups = groups

      scope.unset = () ->
        args = Array.prototype.slice arguments
        for arg in args
          delete scope.selection[arg]

      setCurrent = (newValue) ->
        scope.current_selection =
          newValue['service_offering'] or
          newValue['category'] or
          newValue['subgroup'] or
          newValue['segment'] or
          []

      scope.$watch 'selection', setCurrent, yes

      scope.select = () ->
        $modalInstance.close scope.current_selection

    , (err) ->
      scope.error = yes
    .finally () ->
      scope.loading = no

    scope.selection = {}
]

