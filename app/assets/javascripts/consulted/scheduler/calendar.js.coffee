app = angular.module "consulted.calendar", [
  'ui.bootstrap'
]

app.directive "event", [() ->
  restrict: "A"
  replace: yes
  templateUrl: "event"
  scope:
    event: "="
  link: (scope, el) ->

    {starts, ends} = scope.event
    scope.length = ends.diff(starts, 'minutes')

    scope.dummyClick = (event) ->
      # prevent creating more and more events on clicking the event
      event.stopPropagation()

    scope.save = () ->
      scope.$emit "calendar:event:change", scope.event

    calculate = (newValue, emit = no) ->
      midnight       = starts.clone().hour(0).minute(0).second(0)
      offset         = starts.diff(midnight, 'minutes')
      height         = newValue

      el.css 'height', "#{height/60 * 44}px"
      el.css "top", "#{offset/60 * 44}px"

      scope.event =
        id: scope.event.id
        new_event: scope.new_event
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

    scope.$on "calendar:event:update", (_, obj) ->
      {newEvent, oldEvent} = obj
      if scope.event.id is oldEvent.id
        scope.event = newEvent

]

app.directive "draggable", [() ->
  scope: no
  restrict: "C"
  link: (scope, el) ->
    doc    = document.getElementById 'user_calendar'
    doc    = angular.element doc
    height = 0
    start  = 0
    startY = 0

    doDrag = (e) ->
      newHeight = start + e.clientY - startY
      return if newHeight < 22
      el.parent().css "height", "#{newHeight}px"
      height = newHeight

    stopDrag = (e) ->
      doc.unbind "mousemove"
      doc.unbind "mouseup"
      scope.$emit "calendar:event:height", height

    init = (e) ->
      start = el.parent().prop('clientHeight')
      startY = e.clientY

      doc.bind "mousemove", doDrag
      doc.bind "mouseup", stopDrag

    el.bind 'click', (e) -> e.stopPropagation()
    el.bind "mousedown", init

]

app.directive "dayColumn", [
  'Hash'
  (Hash) ->
    link: (scope, el, attrs) ->
      {s4} = Hash
      scope.add = (event, index) ->
        date   = scope.start_date.clone().add index, 'days'
        #calculate start from offset
        offset = event.offsetY - 10
        hour   = offset/44
        start  = date.clone().hour(0).minute 0
        i      = 0
        while i < hour
          start.add 15, 'minutes'
          i += 0.25
        end    = start.clone().add 1, 'hour'

        values =
          event:
            starts: start
            ends: end
            id: "#{s4()}#{s4()}-#{s4()}#{s4()}"
            new_event: yes
          index: index
        scope.$emit 'calendar:event:new', values

      scope.dummy = (event) -> event.stopPropagation()

]


app.controller "CalendarCtrl", [
  '$scope'
  'AvailabilityData'
  '$timeout'
  '$modal'
  (scope, AvailabilityData, $timeout, modal) ->
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
    scope.start_date = moment().day(1)

    fetch = (_, opts = {}) ->
      defaults =
        week: scope.start_date.isoWeek()
      opts = angular.extend defaults, opts
      scope.loading = yes

      AvailabilityData.getEventsForWeek(opts).then (events) ->
        scope.events = events
      , (err) ->
        scope.err = err
      .finally () ->
        scope.loading = no

    fetch()

    scope.$on "calendar:event:new", (_, value) ->
      {index, event} = value
      newLength = scope.events[index].push event
      newLength -= 1
      AvailabilityData.save(event).then (newEvent) ->
        scope.$broadcast 'calendar:event:update',
          oldEvent: event
          newEvent: newEvent
      , (err) ->
        scope.$broadcast "calendar:event:remove", event.id

    scope.$on "calendar:event:change", (_, event) ->
      AvailabilityData.save(event).then (newEvent) ->
        update newEvent
        return
        # search for event in calendar && update
      , (err) ->
        scope.$broadcast "calendar:event:remove", event.id

    scope.$on "calendar:event:remove", (_, value) ->
      AvailabilityData.remove(value)

    scope.$on "calendar:week:change", fetch

    scope.addDay = (count) ->
      scope.start_date.clone().add count, 'days'

    scope.afterInitial = () ->
      scope.start_date.isAfter moment().day(1)

    switchTimer = null
    step = (count, type = "week") ->
      newDate = scope.start_date.clone().add(count, type).day(1)
      $timeout.cancel switchTimer if switchTimer?
      switchTimer = $timeout ->
        scope.$broadcast "calendar:week:change", week: newDate.isoWeek()
      , 200
      newDate

    update = (newEvent) ->
      [index, idx] = do () ->
        for events, index in scope.events
          for _event, idx in events when _event.id is newEvent.id
            return [index, idx]
      scope.events[index][idx] = newEvent

    scope.remove = (_, event) ->
      AvailabilityData.remove(event.id).then () ->
        [index, idx] = do ->
          for events, index in scope.events
            for _event, idx in events when event.id is _event.id
              return [index, idx]
        scope.events[index].splice idx, 1

    scope.next = () ->
      scope.start_date = step 1

    scope.prev = () ->
      scope.start_date = step -1

    scope.anyEvents = () ->
      return no unless angular.isArray scope.events
      for events in scope.events
        return true if events.length > 0

    scope.collectedEvents = ->
      _events = []
      return _events unless angular.isArray scope.events
      for events in scope.events
        _events.push event for event in events
      _events

    scope.openAddWindow = () ->
      modalInstance = modal.open
        templateUrl: 'addEventWindow'
        controller: 'AddEventCtrl'

      modalInstance.result.then process

    process = (values) ->
      scope.$emit "calendar:event:new", values
]

app.controller 'AddEventCtrl', [
  '$scope'
  '$modalInstance'
  (scope, $modalInstance) ->
    scope.loading = no

]

app.service 'Hash', () ->
  s4:() ->
    Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1)

