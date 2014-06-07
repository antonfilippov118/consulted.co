app = angular.module 'consulted.booking.directives', [
  'consulted.booking.controllers'
]

app.directive 'timeSelect', [
  'Times'
  'Storage'
  (Times, Storage) ->
    replace: yes
    restrict: 'EA'
    templateUrl: 'time_select'
    scope:
      request: '='
    link: (scope) ->
      scope.loading = yes
      temp = no
      selected = no
      lengths = []

      find = (times) ->
        time = Storage.getTime()
        return no unless time

        for _time in times
          return _time if _time.start is time.unix()
        no


      scope.show = (length) -> temp = length
      scope.hide = () -> temp = no
      scope.selected = () -> temp || selected
      scope.isSelected = (length) -> length <= selected

      scope.select = (length) ->
        selected = length
        scope.request.length = selected
        scope.request.active_from = moment(scope.active_from.start * 1000)

      scope.setTime = () ->
        scope.lengths = lengths.filter (length) -> length <= scope.active_from.max_length
        selected = scope.lengths[0]
        scope.request.length = selected
        scope.request.active_from = moment(scope.active_from.start * 1000)

      scope.active_to = () ->
        return moment() unless scope.request?.active_from
        scope.request.active_from.clone().add(scope.selected(), 'minutes')

      scope.add = (min) ->
        scope.request.active_from.add min, 'minutes'

      scope.addable = (min) ->
        min += scope.selected()
        return no if angular.isUndefined scope.request.active_from
        scope.request.active_from.clone().add(min, 'minutes').unix() <= scope.active_from.end

      scope.subtractable = (min) ->
        return no if angular.isUndefined scope.request.active_from
        scope.request.active_from.clone().subtract(min, 'minutes').unix() >= scope.active_from.start

      scope.$on 'data:ready', (_, newOffer) ->
        return if angular.isUndefined newOffer
        Times.get(newOffer).then (times) ->
          lengths = newOffer.lengths.map((length) -> +length).sort (a, b) -> a - b
          scope.times = times.sort((a, b) -> a.start - b.start)
          scope.active_from = find(times) || scope.times[0]
          scope.setTime()
        .finally ->
          scope.loading = no
]

app.directive 'message', [
  () ->
    template: '<div ng-show="message" class="alert alert-warning">{{message}}</div>'
    replace: yes
    scope:
      message: '='

]

app.directive 'language', [
  () ->
    replace: yes
    restrict: 'EA'
    template: '<span ng-class="{\'inactive\':!active()}" ng-click="toggle()">{{language | capitalize}}</span>'
    scope:
      request: '='
      language: '@'
    link: (scope, el, attrs) ->
      {language} = scope
      scope.request.languages = [] unless angular.isArray scope.request.languages
      scope.active = () -> language in scope.request.languages
      scope.request.languages.push language if attrs.selected
      scope.toggle = () ->
        idx = scope.request.languages.indexOf language
        if idx > -1
          return if scope.request.languages.length - 1 is 0
          scope.request.languages.splice idx, 1
        else
          scope.request.languages.push language






]
