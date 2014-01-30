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

    scope.languages = [
      'english'
      'mandarin'
      'spanish'
      'arabic'
      'german'
    ]

    scope.hasLanguage = (lang) ->
      {user} = scope
      return no if user is undefined
      lang in user.languages

    scope.toggleLanguage = (lang) ->
      {user} = scope
      idx    = user.languages.indexOf lang

      if idx > -1
        user.languages.splice idx, 1
      else
        user.languages.push lang

      User.periodicSave user

]

app.controller "UserOffersController", [
  '$scope'
  'Offers'
  'Groups'
  (scope, Offers, Groups) ->
    enabledGroups  = []

    groups = []
    Groups.getGroups().then (data) ->
      groups = data

    Offers.getOffers().then (data) ->
      scope.offers = data
      enabledGroups =  data.map (group) ->
        group._id

    hasGroup = (group) ->
      for offer in scope.offers when offer.group._id is group._id
        return yes
      no

    scope.enabled = (group) ->
      for id in enabledGroups when id is group._id
        return yes
      no

    scope.enabledOffers = () ->
      scope.offers?.length > 0 and enabledGroups.length > 0

    scope.save = ->
      Offers.periodicSave scope.offers

    scope.$on "offers:group:toggle", (e, group) ->
      idx = enabledGroups.indexOf group._id
      if idx > -1
        enabledGroups.splice idx, 1
      else
        enabledGroups.push group._id

      unless hasGroup group
        scope.offers.push { group: group }
        scope.save()

]
