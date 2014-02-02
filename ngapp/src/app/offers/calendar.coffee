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
    starts         = moment starts
    ends           = moment ends
    midnight       = starts.clone().hour(0).minute(0).second(0)
    offset         = starts.diff(midnight, 'minutes')
    height         = ends.diff(starts, 'minutes')

    el.css 'height', "#{height/60 * 44}px"
    el.css "top", "#{offset/60 * 44}px"

    scope.remove = () ->
      # via scope
      return

]

app.directive "dayColumn", [->
  link: (scope, el, attrs) ->
    offsetElement = document.querySelectorAll(".empty")[0]
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
        index: index
      scope.$emit 'calendar:event:new', values

]