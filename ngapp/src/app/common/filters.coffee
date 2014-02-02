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
      moment(input).format format


