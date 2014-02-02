app = angular.module 'consulted.offers.directives', [
  'consulted.calendar'
]

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

app.directive "userOffers", [() ->
  controller: 'UserOffersController'
  templateUrl: 'views/offers/user_offers.tpl.html'
  scope: yes
  replace: yes
]

app.directive "userCalendar", [() ->
  controller: 'UserCalendarController'
  templateUrl: 'views/offers/user_calendar.tpl.html'
  scope:
    user: "="
  replace: yes
]

app.directive "userLanguages", [
  'User'
  (User) ->
    templateUrl: 'views/offers/user_languages.tpl.html'
    scope:
      user: "="
    replace: yes
    link: (scope) ->

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
        return unless !!user
        idx    = user.languages.indexOf lang
        if idx > -1
          user.languages.splice idx, 1
        else
          user.languages.push lang

        User.periodicSave user
]

app.directive 'groupSelect', [->
  templateUrl: 'views/offers/select_groups.tpl.html'
  replace: yes
  scope:
    groups: "="
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