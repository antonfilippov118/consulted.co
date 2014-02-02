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

app.controller "UserCalendarController", [
  '$scope'
  'User'
  (scope, User) ->
    scope.weekdays = [
      'Mon'
      'Tue'
      'Wed'
      'Thu'
      'Fri'
      'Sat'
      'Sun'
    ]

    scope.events = [
      [
        starts: moment("2014-02-03 8:00")
        ends: moment("2014-02-03 10:00")
      #,
      #  starts: "2014-02-03 15:00"
       # ends: "2014-02-03 16:00"
      #,
        #starts: "2014-02-03 13:00"
        #ends: "2014-02-03 14:30"
      ],
      [],
      [],
      [
      #  starts: "2014-02-06 9:00"
      # ends: "2014-02-06 11:00"
      ],
      [
      #  starts: "2014-02-07 12:00"
      #  ends: "2014-02-07 13:15"
      ],
      [],
      []
    ]

    scope.$on "calendar:event:new", (_, value) ->
      {index, event} = value
      scope.events[index].push event

    scope.hours = [0..23]

    scope.start_date = moment().day(1)

    scope.addDay = (count) ->
      scope.start_date.clone().add count, 'days'

    step = (count, type = "week") ->
      scope.start_date.clone().add(count, type).day(1)

    scope.next = () ->
      scope.start_date = step 1

    scope.prev = () ->
      scope.start_date = step -1

]
