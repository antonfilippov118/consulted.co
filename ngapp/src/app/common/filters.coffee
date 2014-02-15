app = angular.module "consulted.common.filters", []

timeFilters = {
  'minute': "mm"
  'hour': "HH:mm"
  'date': "YYYY-MM-DD"
  'datetime': "YYYY-MM-DD HH:mm:ss"
  'datehour': "YYYY-MM-DD HH:mm"
}

angular.forEach timeFilters, (format, key) ->
  app.filter key, ->
    (input) ->
      if moment.isMoment(input)
        return input.format format
      moment(input).format format

app.filter "week", [() ->
  (input, iso = yes) ->
    input = moment(input) unless moment.isMoment input
    return input.isoWeek() if iso
    return input.week()
]


