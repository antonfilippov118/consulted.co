app = angular.module "consulted.offers.controllers", [
  'consulted.users.services'
  'consulted.groups.services'
  'consulted.offers.services'
]

app.controller "OfferController", [
  '$scope'
  'User'
  'Groups'
  (scope, User, Groups) ->

    User.getProfile().then (user) ->
      scope.user = user

    Groups.getGroups().then (groups) ->
      scope.groups = groups
]

app.controller "UserOffersController", [
  '$scope'
  'Offers'
  'Groups'
  (scope, Offers, Groups) ->
    enabledOffers  = []

    groups = []
    Groups.getGroups().then (data) ->
      groups = data

    Offers.getOffers().then (data) ->
      scope.offers = data
      enabledOffers =  data.map (offer) ->
        offer._group_id

    hasGroup = (group) ->
      for offer in scope.offers when offer._group_id is group._id.$oid
        return yes
      no

    toggleOffer = (oid) ->
      for offer in scope.offers when offer._group_id is oid
        offer.enabled = !offer.enabled

    scope.possibleLengths = [
      '30'
      '45'
      '60'
      '90'
      '120'
    ]

    scope.hasLength = (length, offer) ->
      return no unless angular.isArray offer.lengths
      "#{length}" in offer.lengths

    scope.toggleLength = (length, offer)->
      offer.lengths = [] unless angular.isArray offer.lengths
      idx = offer.lengths.indexOf("#{length}")
      if idx > -1
        offer.lengths.splice idx, 1
      else
        offer.lengths.push length
      scope.save()

    scope.enabledOffers = () ->
      return no if !scope.offers
      for offer in scope.offers when offer.enabled is yes
        return yes
      no

    scope.save = ->
      Offers.periodicSave scope.offers

    scope.$on "offers:group:toggle", (e, group) ->
      idx = enabledOffers.indexOf group._id.$oid
      if idx > -1
        enabledOffers.splice idx, 1
      else
        enabledOffers.push group._id.$oid

      unless hasGroup group
        scope.offers.push
          name: group.name
          # this is necessary as angular currently strips keys starting with $
          _group_id: group._id.$oid

      toggleOffer group._id.$oid
      scope.save()

]
