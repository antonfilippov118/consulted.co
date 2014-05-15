app = angular.module 'consulted.overview.services', []

app.service 'Call', [
  '$http'
  '$q'
  (http, q) ->
    getCalls: () ->
      result = q.defer()
      http.get('/calls.json').then (response) ->
        result.resolve response.data
      result.promise

]
