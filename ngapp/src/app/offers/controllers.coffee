app = angular.module "consulted.offers.controllers", [
  'consulted.users.services'
  'consulted.groups.services'
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

      #User.periodicSave user

]
