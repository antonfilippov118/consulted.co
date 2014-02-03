app = angular.module "consulted.common.filters", []

timeFilters = {
  'minute': "mm"
  'hour': "HH:mm"
  'date': "YYYY-MM-DD"
  'datetime': "YYYY-MM-DD"
  'week': 'W'
}

angular.forEach timeFilters, (format, key) ->
  app.filter key, ->
    (input) ->
      if moment.isMoment(input)
        return input.format format
      moment(input).format format


