app = angular.module "consulted.calendar", [
  'consulted.common.filters'
]

app.directive "event", [() ->
  restrict: "A"
  scope:
    event: "="
  link: (scope, el) ->
    {starts, ends} = scope.event
    starts         = moment starts
    ends           = moment ends
    midnight       = starts.clone().hour(0).minute(0).second(0)
    offset         = starts.diff(midnight, 'minutes')
    height         = ends.diff(starts, 'minutes')
    console.log height/60*44
    el.css 'height', "#{height/60 * 44}px"
    el.css "top", "#{offset/60 * 44}px"

]

app.directive "dayColumn", [() ->
  link: (scope, el) ->

]