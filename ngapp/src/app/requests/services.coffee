app = angular.module 'consulted.requests.services', []

app.service "Search", [
  '$http'
  '$q'
  (http, q) ->
    perform: (options) ->
      result = q.defer()
      http.post('/search', options).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise
]
