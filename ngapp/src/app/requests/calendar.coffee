app = angular.module "consulted.requests.calendar", []

app.directive "searchCalendar", [
  () ->
    replace: yes
    templateUrl: 'views/requests/calendar/calendar.tpl.html'
    controller: 'RequestCalendarCtrl'
]

app.controller 'RequestCalendarCtrl', [
  '$scope'
  (scope) ->
    scope.start_date = moment()

    scope.weekdays = [
      'Mon'
      'Tue'
      'Wed'
      'Thu'
      'Fri'
      'Sat'
      'Sun'
    ]
    scope.hours = [0..23]
    week        = moment().isoWeek()
    scope.start_date = moment().day(1)

    week_events = {}

    remove = (_, id) ->
      events = scope.events()
      for day in events
        for event, index in day
          if event.id is id
            day.splice index, 1

    step = (count, type = "week") ->
      week += count
      scope.start_date.clone().add(count, type).day(1)

    update = () ->
      scope.$emit "calendar:update", scope.times()

    scope.next = () ->
      scope.start_date = step 1

    scope.prev = () ->
      scope.start_date = step -1

    scope.times = () ->
      times = []
      for ts, days of week_events
        for day in days
          times.push event for event in day
      times

    scope.clear = () ->
      week_events = {}
      update()

    scope.maxedOut = () ->
      scope.times().length >= 5

    scope.events = () ->
      ts = scope.start_date.unix()
      if week_events[ts] is undefined
        week_events[ts] = [[],[],[],[],[],[],[]]
      week_events[ts]

    scope.$on "calendar:event:new", (_, event) ->
      scope.events()[event.index].push event
      update()

    scope.$on "calendar:event:remove", (_, id)->
      remove _, id
      update()

    scope.$on 'calendar:event:change', (_, _event) ->
      ts = scope.start_date.unix()
      for day, index in week_events[ts]
        for event, idx in day when event.id is _event.id
          week_events[ts][index][idx].ends = _event.ends
      scope.$digest()
      update()


]

app.directive "searchDayColumn", [
  'Hash'
  (Hash) ->
    link: (scope, el, attrs) ->
      {s4} = Hash

      scope.add = (event, index) ->
        return if scope.maxedOut() is yes

        date   = scope.start_date.clone().add index, 'days'
        #calculate start from offset
        offset = event.layerY - 10
        hour   = offset/44
        start  = date.clone().hour(0).minute 0
        i      = 0
        while i < hour
          start.add 15, 'minutes'
          i += 0.25

        end = start.clone().add 1, 'hour'

        event =
          starts: start
          ends: end
          index: index
          id: "#{s4()}#{s4()}-#{s4()}#{s4()}"

        scope.$emit 'calendar:event:new', event

      scope.dummy = (event) -> event.stopPropagation()

]

app.directive 'searchEvent', [
  () ->
    restrict: "A"
    replace: yes
    templateUrl: "views/requests/calendar/event.tpl.html"
    scope:
      event: "=searchEvent"
    link: (scope, el) ->
      {starts, ends} = scope.event
      scope.length = ends.diff(starts, 'minutes')

      scope.dummyClick = (event) ->
        # prevent creating more and more events on clicking the event
        event.stopPropagation()

      calculate = (newValue, emit = no) ->
        midnight       = starts.clone().hour(0).minute(0).second(0)
        offset         = starts.diff(midnight, 'minutes')
        height         = newValue

        el.css 'height', "#{height/60 * 44}px"
        el.css "top", "#{offset/60 * 44}px"

        scope.event =
          id: scope.event.id
          starts: starts
          ends: starts.clone().add newValue, 'minutes'

        scope.$emit "calendar:event:change", scope.event if emit

      calculate(scope.length)

      scope.remove = (event) ->
        event.stopPropagation()
        el.remove()
        scope.$emit "calendar:event:remove", scope.event.id

      scope.$on "calendar:event:height", (_, height) ->
        times = Math.ceil(height / 11)
        calculate 15 * times, yes

]
