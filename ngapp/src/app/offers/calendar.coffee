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

    scope.$on 'calendar:event:resize', (_, amount) ->
      {starts, ends} = scope.event
      starts         = moment starts
      ends           = moment(ends).add amount, 'minutes'
      midnight       = starts.clone().hour(0).minute(0).second(0)
      offset         = starts.diff(midnight, 'minutes')
      height         = ends.diff(starts, 'minutes')

      scope.event =
        starts: starts
        ends: ends

      el.css 'height', "#{height/60 * 44}px"
      el.css "top", "#{offset/60 * 44}px"

    scope.remove = () ->
      scope.$emit "calendar:event:remove", scope.event.id

    scope.$emit 'calendar:event:resize', 0

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
        index: index
      scope.$emit 'calendar:event:new', values

]