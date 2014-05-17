app = angular.module 'consulted.finder.directives', [
  'consulted.finder.controllers'
  'consulted.finder.services'
]

app.directive 'filter', [
  () ->
    replace: yes
    templateUrl: 'filter'
    controller: 'FilterCtrl'
    scope: yes
]

app.directive 'languages', [
  'Language'
  (Language) ->
    scope: yes
    replace: no
    link: (scope) ->
      scope.languages = Language.getLanguages()
      scope.isActive  = Language.isActive
      scope.toggleAll = Language.toggleAll
      scope.allActive = Language.allActive
      scope.toggle    = Language.toggle
]
app.directive 'continents', [
  'Continent'
  (Continent) ->
    scope: yes
    replace: no
    link: (scope) ->
      scope.continents = Continent.getContinents()
      scope.isActive   = Continent.isActive
      scope.toggle     = Continent.toggle
      scope.toggleAll  = Continent.toggleAll
      scope.allActive  = Continent.allActive
]

app.directive 'rate', [
  'Rate'
  'Configuration'
  (Rate, Configuration) ->
    replace: no
    scope: yes
    link: (scope, el) ->
      scope.rate    = Configuration.getRates()
      scope.rates   = Configuration.getRates
      scope.setRate = () ->
        Rate.set scope.rate.from, scope.rate.to

]

app.directive 'experience', [
  'Experience'
  'Configuration'
  (Experience, Configuration) ->
    replace: no
    scope: yes
    link: (scope, el) ->
      scope.experience    = Configuration.getExperiences()
      scope.experiences   = Configuration.getExperiences
      scope.setExperience = () ->
        Experience.set scope.experience.from, scope.experience.to
]

app.directive 'dates', [
  'Date'
  (Date) ->
    replace: no
    scope: yes
    link: (scope) ->
      scope.days      = Date.availableDays()
      scope.fortnight = -> Date.isFortnight()
      scope.all       = -> Date.fortnight yes
      scope.specific  = -> Date.fortnight no
      scope.toggle    = Date.toggle
      scope.selected  = Date.selected
]

app.directive 'times', [
  'Time',
  TimeDirective = (Time) ->
    replace: no
    scope: yes
    link: (scope) ->
      scope.times    = Time.availableTimes()
      scope.allDay   = -> Time.isAllDay()
      scope.all      = -> Time.allDay yes
      scope.specific = -> Time.allDay no
      scope.toggle   = Time.toggle
      scope.selected = Time.selected

]

app.directive 'bookmark', [
  'Bookmark'
  (Bookmark) ->
    replace: no
    scope: yes
    link: (scope) ->
      scope.isActive = Bookmark.isActive
      scope.toggle   = Bookmark.toggle

]

app.directive 'tags', [
  'Tag'
  (Tag) ->
    scope: yes
    replace: no
    link: (scope) ->
      scope.tags   = Tag.getTags()
      scope.remove = Tag.remove
      scope.add    = () ->
        if scope.adding isnt yes
          return scope.adding = yes
        Tag.add scope.next_tag
        scope.next_tag = ""
        scope.adding = no

]

app.directive 'result', [
  () ->
    replace: yes
    templateUrl: 'result'
    scope: yes
    controller: 'ResultCtrl'
]

app.directive 'offer', [
  'Bookmark'
  BookmarkDirective = (Bookmark) ->
    replace: yes
    templateUrl: 'offer'
    scope:
      offer: "="
    link: (scope) ->
      scope.showDescription = no
      scope.toggleDescription = () ->
        scope.showDescription = !scope.showDescription

      scope.showToggle = scope.offer.expert.companies?.length > 3
      allCareer = no
      scope.allActive = -> allCareer
      scope.careerLimit = () ->
        if allCareer
          1000
        else
          3

      scope.toggleCareer = () ->
        allCareer = !allCareer

      scope.bookmark = (expert) ->
        expert.bookmarked = !expert.bookmarked
        Bookmark.send expert

]

app.directive 'ionRangeMulti', [
  '$timeout'
  'Configuration'
  (timeout, Configuration) ->
    scope:
      values: "="
    require: '?ngModel'
    link: (scope, el, attrs, ngModel) ->
      apply = (obj) ->
        scope.$apply () ->
          ngModel.$setViewValue from: obj.fromNumber, to: obj.toNumber

      build = (value) ->
        {from, to} = scope.values()
        el.ionRangeSlider('remove').ionRangeSlider
          type: 'double'
          min: from
          max: to
          from: from
          to: to
          hideMinMax: yes
          postfix: do -> if attrs.postfix then " #{attrs.postfix}" else undefined
          prefix: do -> if attrs.prefix then " #{attrs.prefix}" else undefined
          onFinish: apply

      update = (value) ->
        {from, to} = value
        el.ionRangeSlider 'update', from: from, to: to

      scope.$watch () ->
        ngModel.$modelValue
      , (newValue) ->
        return unless newValue
        update newValue

      scope.$on 'open', (_, open) ->
        timeout ->
          build ngModel.$modelValue if open
        , 50

      el.ionRangeSlider()

]
