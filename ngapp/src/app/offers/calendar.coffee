app = angular.module "consulted.calendar", [
  'consulted.common.filters'
]

app.directive "event", [() ->
  restrict: "A"
  replace: yes
  templateUrl: "views/offers/calendar/event.tpl.html"
  scope:
    event: "="
  link: (scope, el) ->
    {starts, ends} = scope.event
    scope.length = ends.diff(starts, 'minutes')

    scope.$watch "length", (newValue) ->
      midnight       = starts.clone().hour(0).minute(0).second(0)
      offset         = starts.diff(midnight, 'minutes')
      height         = newValue

      el.css 'height', "#{height/60 * 44}px"
      el.css "top", "#{offset/60 * 44}px"

      scope.starts = starts
      scope.ends   = starts.clone().add newValue, 'minutes'

      scope.$emit "calendar:event:change"

    scope.remove = () ->
      scope.$emit "calendar:event:remove", scope.event.id

    scope.$on "calendar:event:height", (_, height) ->
      times = Math.ceil(height / 11)
      scope.$apply -> scope.length = 15 * times

]

app.directive "draggable", [() ->
  scope: no
  restrict: "C"
  link: (scope, el) ->
    doc    = angular.element(document)
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
      doc.unbind "mousedown"
      scope.$emit "calendar:event:height", height

    init = (e) ->
      start = el.parent().prop('clientHeight')
      startY = e.clientY

      doc.bind "mousemove", doDrag
      doc.bind "mouseup", stopDrag

    el.bind "mousedown", init

]

app.directive "dayColumn", [->
  link: (scope, el, attrs) ->
    s4 = () ->
      Math.floor((1 + Math.random()) * 0x10000)
          .toString(16)
          .substring(1)

    scope.add = (event, index) ->
      date   = scope.start_date.clone().add index, 'days'
      #calculate start from offset
      offset = event.layerY - 10
      hour   = offset/44
      start  = date.clone().hour(0).minute 0
      i      = 0
      while i < hour
        start.add 15, 'minutes'
        i += 0.25
      end    = start.clone().add 0.5, 'hour'

      values =
        event:
          starts: start
          ends: end
          id: "#{s4()}#{s4()}-#{s4()}#{s4()}"
          new_event: yes
        index: index
      scope.$emit 'calendar:event:new', values

]


app.controller "CalendarController", [
  '$scope'
  'Availabilities'
  (scope, Availabilities) ->
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
        starts: moment("2014-02-03 3:00")
        ends: moment("2014-02-03 5:00")
        id: "foobar"
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
      newLength = scope.events[index].push event
      newLength -= 1
      Availabilities.save(event).then (newEvent) ->
        event.id = newEvent._id.$oid
        event.new_event = no
      , (err) ->
        scope.$broadcast "calendar:event:remove", event.id



    scope.$on "calendar:event:change", (_, event) ->
      #Availabilities.periodicSave(event).then (newEvent) ->
        # search for event in calendar && update

    scope.$on "calendar:event:remove", (_, value) ->
      console.log value


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