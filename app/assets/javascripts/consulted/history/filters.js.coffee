app = angular.module 'consulted.history.filters', []

app.filter 'status', [
  () ->
    (input, status) ->
      return [] unless angular.isArray input
      input.filter (obj) -> obj.status is status

]
